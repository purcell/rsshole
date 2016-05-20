module Store
  (
    Store
  , defaultStore
  )
where


data Store = Store { storeDir :: FilePath }


defaultStore :: FilePath -> IO Store
defaultStore = return . Store
