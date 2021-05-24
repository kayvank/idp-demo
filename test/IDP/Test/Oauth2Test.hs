-- |
module IDP.Test.Oauth2Test where

import Test.Tasty.HUnit
import Test.Tasty

testTree :: TestTree
testTree =
  testGroup
    "Oauth2 Specifications"
    [ testCase "get IDP" testIdp
    ]

testIdp :: Assertion
testIdp = assertBool "fake-test!!!" True
