module Day01 (run) where

import Data.List.Split (splitOn)
import Data.List (transpose, sort)
import Control.Monad (liftM2, ap)

{- Main -}
run :: IO ()
run = do
  input <- readFile "input.txt"
  let numbers = liftM2 (,) head last . map sort . transpose . map (map read . splitOn "   ") $ lines input
  putStrLn $ "Part 1: " ++ show (part1 numbers)
  putStrLn $ "Part 2: " ++ show (part2 numbers)

{- Implementation -}
-- Part 1: sum of the differences between each pair of 2 sorted ascending lists
part1 :: ([Int], [Int]) -> Int
part1 = uncurry (((sum . map abs) .) . zipWith (-))

-- Part 2: sum of the multiples of each element on the first array with the number of occurrences of that element on the second array
part2 :: ([Int], [Int]) -> Int
part2 = uncurry (flip ((sum .) . map . ap (*) . flip ((length .) . filter . (==))))