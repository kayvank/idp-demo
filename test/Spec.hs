import Test.Tasty
import Test.Tasty.HUnit
import qualified IDP.Test.Oauth2Test as Oauth2Test


main :: IO ()
main = defaultMain  =<< idpTestTree

idpTestTree :: IO TestTree
idpTestTree = do
  pure $ testGroup "idp-specification" [
    Oauth2Test.testTree
                             ]
