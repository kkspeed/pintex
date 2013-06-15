#!/usr/bin/runhaskell

import System.Environment (getArgs)
import System.IO (readFile, writeFile)
import Data.Char (isSpace)
import Text.Regex.PCRE ((=~))
import HSH (runIO)
import System.FilePath (dropExtensions)

main :: IO()
main = do
  input:output:_ <- getArgs
  putStrLn "Compiling tex file ..."
  runIO $ "xelatex " ++ input
  runIO $ "xelatex " ++ input
  putStrLn "Converting file ..."
  runIO $ "convert -density 160 " ++ ((++".pdf") . dropExtensions) input ++
            " presentation.png"
  putStrLn $ "Generating " ++ output ++ ".."
  text <- readFile input
  writeFile output . (parse 0 False) . lines $ text

parse :: Int -> Bool -> [String] -> String
parse slides inframe remains@(l:ls)
    | l =~ "^\\\\begin\\{frame\\}" = (emitFrameOpen slides l "") ++
           (parse slides True ls)
    | l =~ "\\\\pause" = (emitFrameOpen (slides+1) l "[transition=text-still]") ++
           (parse (slides+1) True ls)
    | l =~ "^\\\\end\\{frame\\}" = parse (slides+1) False ls
    | l =~ "^\\s*$" = parse slides inframe ls
    | otherwise = parse' slides inframe False remains
parse slides _ [] = ""

parse' :: Int -> Bool -> Bool -> [String] -> String
parse' slides True False (l:ls)
    | l =~ "\\\\begin\\{pinpoint\\}" = parse' slides True True ls
    | otherwise = parse slides True ls
parse' slides True True (l:ls)
    | l =~ "\\\\end\\{pinpoint\\}" = parse' slides True False ls
    | otherwise = (trim l) ++ "\n" ++ (parse' slides True True ls)
parse' slides False False (l:ls)
    | l =~ "\\\\begin\\{pinpoint\\}" = "\n" ++ parse' slides False True ls
    | otherwise = parse slides False ls
parse' slides False True (l:ls)
    | l =~ "\\\\end\\{pinpoint\\}" = parse' slides False False ls
    | otherwise = (trim l) ++ "\n" ++ (parse' slides False True ls)

emitFrameOpen :: Int -> String -> String -> String
emitFrameOpen slides l attrs
    | not . null $ attributes = "\n\n--" ++ (attributes!!0!!1) ++ attrs ++ pngFile
    | otherwise = "\n\n--[duration=4.0][text-align=center]" ++ attrs ++ pngFile
    where attributes = l =~ "%.*pin:(.*)" :: [[String]]
          pngFile = "[presentation-" ++ (show slides) ++ ".png]\n"

trim xs = dropSpaceTail "" $ dropWhile isSpace xs
dropSpaceTail maybeStuff "" = ""
dropSpaceTail maybeStuff (x:xs)
        | isSpace x = dropSpaceTail (x:maybeStuff) xs
        | null maybeStuff = x : dropSpaceTail "" xs
        | otherwise       = reverse maybeStuff ++ x : dropSpaceTail "" xs
