module Main where

import           Data.Maybe (catMaybes)
import           Scrape
import           Store

main :: IO ()
main = do
  store <- defaultStore "data"
  uris <- lines <$> readFile "urls.txt"
  scrapeAll (catMaybes (parseFeedURI <$> uris)) store
