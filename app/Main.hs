module Main where

import           Data.Maybe (catMaybes)
import           Scrape
import           Store

main :: IO ()
main = do
  store <- defaultStore "data"
  uris <- lines <$> readFile "urls.txt"
  result <- scrape $ head (catMaybes (parseFeedURI <$> uris))
  print result
  --scrapeAll (catMaybes (parseFeedURI <$> uris)) store
