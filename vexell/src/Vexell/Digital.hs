module Vexell.Digital where

import Foreign
import Foreign.C.Types
import Jhc.Type.C
import Data.Maybe

type PinNumber = CInt
data DigitalPin = DigitalPin PinNumber
data DigitalMode = DigitalInput | DigitalOutput deriving (Enum)
data DigitalState = Low | High deriving (Eq, Enum)

digitalPin :: PinNumber -> Maybe DigitalPin
digitalPin n
  | n < 0 || n > 12 = Nothing -- pins bound check
  | otherwise       = Just $ DigitalPin $ n - 1

digitalState :: DigitalState -> CInt
digitalState Low  = 0
digitalState High = 1

foreign import capi "c_extern.h vexDigitalModeSet"
  c_vexDigitalModeSet :: CInt -> CInt -> IO ()
vexDigitalModeSet = c_vexDigitalModeSet

foreign import capi "c_extern.h vexDigitalModeGet"
  c_vexDigitalModeGet :: CInt -> IO CInt
vexDigitalModeGet = c_vexDigitalModeGet

foreign import capi "c_extern.h vexDigitalPinSet"
  c_vexDigitalPinSet :: CInt -> CInt -> IO ()
digitalPinSet :: Maybe DigitalPin -> DigitalState -> IO ()
digitalPinSet Nothing _ = return ()
digitalPinSet (Just (DigitalPin p)) s = c_vexDigitalPinSet p $ digitalState s

foreign import capi "c_extern.h vexDigitalPinGet"
  c_vexDigitalPinGet :: CInt -> IO CInt
digitalPinGet :: Maybe DigitalPin -> IO DigitalState
digitalPinGet Nothing = return Low
digitalPinGet (Just (DigitalPin p)) = do
  v <- c_vexDigitalPinGet p
  return $ if v > 0 then High else Low

foreign import capi "c_extern.h vexDigitalIntrSet"
  c_vexDigitalIntrSet :: CInt -> IO ()
vexDigitalIntrSet = c_vexDigitalIntrSet

foreign import capi "c_extern.h vexDigitalIntrRun"
  c_vexDigitalIntrRun :: IO ()
vexDigitalIntrRun = c_vexDigitalIntrRun

foreign import capi "c_extern.h vexDigitalIntrCountGet"
  c_vexDigitalIntrCountGet :: CInt -> IO CWint
vexDigitalIntrCountGet = c_vexDigitalIntrCountGet

foreign import capi "c_extern.h vexExtIrqInit"
  c_vexExtIrqInit :: IO ()
vexExtIrqInit = c_vexExtIrqInit
