module Scrape
  (
    FeedURI
  , parseFeedURI
  , scrapeAll
  )
where

import           Data.Default.Class (def)
import           Data.Time.Interval
import           Data.Time.Units
import           Network.URI        (URI, parseURI, uriToString)
import           Store
import           System.IO          (hPutStrLn, stderr)
import           Text.Feed.Types
import           Web.Feed.Collect



newtype FeedURI = FeedURI { feedURI :: URI }

parseFeedURI :: String -> Maybe FeedURI
parseFeedURI s = FeedURI <$> parseURI s

scrapeAll :: [FeedURI] -> Store -> IO ()
scrapeAll uris store =
 run def
  { wcCollect       = collect store
  , wcLogError      = logError
  , wcVisitInterval = time (15 :: Minute)
  , wcMaxItems      = 10
  , wcFeeds         = feedConfigFromURI <$> uris
  }

feedConfigFromURI :: FeedURI -> FeedConfig
feedConfigFromURI u = mkFeed s s
  where s = uriToString id (feedURI u) ""


collect :: Store -> Label -> Url -> Feed -> Item -> IO ()
collect store label url feed item = do
    putStrLn $ label ++ " : " ++ url
    putStrLn "Got a new feed item!"
    putStrLn $ showFeed feed
    putStrLn $ showItem item


logError :: Label -> Error -> IO ()
logError l e = hPutStrLn stderr $ "ERROR: " ++ l ++ " : " ++ show e

