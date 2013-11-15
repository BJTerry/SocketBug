{-# LANGUAGE PackageImports #-}
import Application (getApplicationDev, webSocketHandler)
import Network.Wai.Handler.Warp
    (runSettings, defaultSettings, settingsPort, settingsIntercept)
import Control.Concurrent (forkIO)
import System.Directory (doesFileExist, removeFile)
import System.Exit (exitSuccess)
import Control.Concurrent (threadDelay)
import Network.Wai.Handler.WebSockets (intercept)

--main :: IO ()
--main = defaultMain (fromArgs parseExtra) makeApplication

main :: IO ()
main = do
    putStrLn "Starting devel application"
    (port, app) <- getApplicationDev
    runSettings defaultSettings
        { settingsPort = port
        , settingsIntercept = intercept $ webSocketHandler
        } app
    loop

loop :: IO ()
loop = do
  threadDelay 100000
  e <- doesFileExist "yesod-devel/devel-terminate"
  if e then terminateDevel else loop

terminateDevel :: IO ()
terminateDevel = exitSuccess
