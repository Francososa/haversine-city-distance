module Lib
    ( locationDB
    , haversine
    , printDistance
    ) where

import Lib.Types
import qualified Data.Map as Map

locationDB :: Map.Map String LatLong
locationDB = Map.fromList [("Arkham",(42.6054,-70.7829))
                          ,("Innsmouth",(42.8250,-70.8150))
                          ,("Carcosa",(29.9714,-90.7694))
                          ,("New York",(40.7776,-73.9691))]


toRadians :: Double -> Double
toRadians degrees = degrees * pi / 180

latLongToRads :: LatLong -> (Double,Double)
latLongToRads (lat,long)  = (rlat,rlong)
  where
    rlat = toRadians lat
    rlong = toRadians long

haversine :: LatLong -> LatLong -> Double
haversine coords1 coords2 = earthRadius * c
  where
    (rlat1,rlong1) = latLongToRads coords1
    (rlat2,rlong2) = latLongToRads coords2
    dlat = rlat2 - rlat1
    dlong = rlong2 - rlong1
    a = (sin (dlat/2))^2 + cos rlat1 * cos rlat2 * (sin (dlong/2))^2
    c = 2 * atan2 (sqrt a) (sqrt (1-a))
    earthRadius = 3961.0


haversineMaybe :: Maybe LatLong -> Maybe LatLong -> Maybe Double
haversineMaybe (Just val1) (Just val2) = Just (haversine val1 val2)
haversineMaybe _ _ = Nothing


haversineIO :: IO LatLong -> IO LatLong -> IO Double
haversineIO ioVal1 ioVal2 = do
  val1 <- ioVal1
  val2 <- ioVal2
  let dist = haversine val1 val2
  return dist


haverIO :: IO LatLong -> IO LatLong -> IO Double
haverIO ioVal1 ioVal2 = haversine <$> ioVal1 <*> ioVal2


printDistance :: Maybe Double -> IO ()
printDistance Nothing = putStrLn "Error, invalid city entered"
printDistance (Just distance) = putStrLn (show distance ++ " miles")
