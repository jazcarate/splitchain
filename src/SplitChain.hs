module SplitChain where

import Git
import Git.Libgit2 (lgFactory, LgRepo(..))
import qualified Data.Text as T


hello :: String
hello = "hello world"



repoOptions :: RepositoryOptions
repoOptions = RepositoryOptions { repoPath = ".git"
                                , repoWorkingDir = Nothing
                                , repoIsBare = False
                                , repoAutoCreate = False }
  
main :: IO ()
main = do
  repo <- openRepository lgFactory repoOptions
  runReaderT printLastCommitMessage repo
  
printLastCommitMessage = do
  ref <- resolveReference $ T.pack "HEAD"
  case ref of
    Nothing -> fail $ "Could not resolve reference named 'HEAD'"
    Just reference -> do
      obj <- lookupObject reference
      case obj of
        CommitObj commit -> lift $ print $ show $ commitLog commit
        _ -> fail $ "'HEAD' is not a commit object"