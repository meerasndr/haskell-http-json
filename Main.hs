{-# LANGUAGE OverloadedStrings #-}
--OverloadedStrings is a language extension, makes literal strings more flexible
--URL is automatically parsed into a Request

module Main where
-- Below imports allow us to make HTTP requests and work with bytestrings
import           Network.HTTP.Simple    ( httpBS, getResponseBody)
import qualified Data.ByteString.Char8  as BS
import          Control.Lens            ( preview )
import          Data.Aeson.Lens         ( key, _String)
import          Data.Text               ( Text )
import qualified Data.Text.IO           as TIO


--fetchJSON fetches the JSON from URL by making the actual HTTP request and returns response body
fetchJSON :: IO BS.ByteString
fetchJSON = do
  result <- httpBS "https://api.coindesk.com/v1/bpi/currentprice.json"
  return (getResponseBody result)

--preview helps extract the exact data we want from the bigger JSON.
-- We want the USD exchange rate from the json

getRate :: BS.ByteString -> Maybe Text
getRate = preview (key "bpi" . key "USD" . key "rate" . _String)

--printing the json as a ByteString
main :: IO ()
main = do
  json <- fetchJSON

  case getRate json of
    Nothing   -> TIO.putStrLn "Bitcoin rate unavailable"
    Just rate -> TIO.putStrLn $ "The current Bitcoin rate is " <>rate<>" USD"
