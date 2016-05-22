module Scrape
  (
    FeedURI
  , parseFeedURI
  , scrape
  )
where

import           Control.Monad.Except
import           Network.HTTP         (getRequest, getResponseBody, simpleHTTP)
import           Network.URI          (URI, parseURI, uriToString)
import           Text.Feed.Import     (parseFeedString)
import           Text.Feed.Types

newtype FeedURI = FeedURI { feedURI :: URI }

data Error = HTTPError String
           | BadFeed
           deriving Show

type Result = Either Error

type FeedFetch = ExceptT Error IO

toString :: FeedURI -> String
toString u = uriToString id (feedURI u) ""

parseFeedURI :: String -> Maybe FeedURI
parseFeedURI s = FeedURI <$> parseURI s

scrape :: FeedURI -> IO (Result Feed)
scrape u = runExceptT $ do
  parsed <- parseFeedString <$> retrieveFeed u
  case parsed of
    Just feed -> return feed
    Nothing -> throwError BadFeed

retrieveFeed :: FeedURI -> FeedFetch String
retrieveFeed u = do
  response <- liftIO . simpleHTTP . getRequest . toString $ u
  liftIO $ getResponseBody response

