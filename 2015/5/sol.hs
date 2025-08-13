#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (p: [ ])"
#! nix-shell -i runghc

-- imports

import Data.Map (Map)
import qualified Data.Map as M

import Data.List (isInfixOf, nub)

import Control.Monad (liftM2)

-- solution composition

main :: IO ()
-- main = print =<< sol2
main = print $ (\l -> not . any (liftM2 (==) head last) $ windows 2 [0..length (windows 2 l) - 1]) $ "aaa"

fileContent :: IO String
fileContent = readFile "./input"

sol :: (LineData -> Bool) -> IO Int
sol isnice = pure . length . (filter isnice) . M.elems . parseInput =<< fileContent

sol1 :: IO Int
sol1 = sol isNice

sol2 :: IO Int
sol2 = sol isNice'

-- input parsing

type FileData = Map String LineData
data LineData = LineData { content :: String
                         , vowels :: [Char]
                         , vowelCount :: Int
                         , consonants :: [Char]
                         , consonantCount :: Int
                         } deriving Show

parseInput :: String -> FileData
parseInput s = M.fromList $ zip ls $ map parseLine ls
  where ls = lines s

parseLine :: String -> LineData
parseLine l = LineData { content = l
                       , vowels = vs
                       , vowelCount = length vs
                       , consonants = cs
                       , consonantCount = length cs
                       } where
                            vs = filter (`elem`"aoeui") l
                            cs = filter (`notElem`"aoeui") l

-- helper functions

rotate :: Int -> [a] -> [a]
rotate _ [] = []
rotate n xs = zipWith const (drop n (cycle xs)) xs

windows :: Int -> [a] -> [[a]]
windows n xs = take (l-n+1) $ map (take n) rots
  where 
    l = length xs
    rots = map (`rotate` xs) [0..l-1]

isPalindrome :: Eq a => [a] -> Bool
isPalindrome xs = firstHalf == secondHalf 
  where
    firstHalf = take half xs
    secondHalf = reverse $ take half $ reverse xs
    half = (length xs) `div` 2

occurenceCount :: (Ord a, Eq a) => [a] -> [Int]
occurenceCount xs = rec xs M.empty
  where
    rec [] _ = []
    rec (x:xs) mem = case M.lookup x mem of
        Just i -> i : rec xs (M.adjust (+1) x mem)
        Nothing -> 0 : rec xs (M.insert x 1 mem)

-- problem solution algorithms

isNice :: LineData -> Bool
isNice ld = atLeastThreeVowels && atLeastOneDoubleLetter && noIllegalSubstrings
  where
    atLeastThreeVowels = vc >= 3
    atLeastOneDoubleLetter = or $ drop 1 $ reverse $ zipWith (==) (rotate 1 l) l
    noIllegalSubstrings = null $ filter (`isInfixOf` l) illegalSubstrings
    illegalSubstrings = ["ab", "cd", "pq", "xy"]
    l = content ld
    vc = vowelCount ld

isNice' :: LineData -> Bool
isNice' ld = containsPairWithoutOverlapping && containsThreeLetterSandwich
  where
    containsPairWithoutOverlapping = containsPair && notOverlapping
    containsPair = any (/=0) $ occurenceCount $ windows 2 l
    notOverlapping = not . any (liftM2 (==) head last) $ windows 2 [0..length (windows 2 l) - 1]
    containsThreeLetterSandwich = not . null $ filter isPalindrome $ windows 3 l
    l = content ld
