
\begin{code}

module IAUtil where


import Data.Maybe

\end{code}


Basic utility stuff,

\begin{code}
infixr 8 .:
(.:) :: (c->d) ->(a->b->c) -> (a->b->d)
(.:) = (.) . (.)

infixr 8 .::
(.::) :: (d->e) -> (a->b->c->d) -> (a->b->c->e)
(.::) = (.) . (.) . (.)

fst3 (x,_,_) = x
snd3 (_,x,_) = x
thd3 (_,_,x) = x


head' = listToMaybe
tail' xs = if null xs then Nothing else Just $ tail xs


listFstFilter :: [(Bool,a)] -> [a]
listFstFilter xs = foldr (\x list -> if fst x then snd x : list else list ) [] xs

--again I assume that there is a prelude function for this
deleteAll :: Eq a => a -> [a] -> [a]
deleteAll = filter . (/=)

--based on the last of the tuple
findLowSnd2 :: Ord b => [(a,b)] -> Maybe (a,b)
findLowSnd2 [] = Nothing
findLowSnd2 (x:xs) = Just $ foldr (\a b -> if (snd a) <= (snd b) then a else b ) x xs
 
findHighSnd2 :: Ord b => [(a,b)] -> Maybe (a,b)
findHighSnd2 [] = Nothing
findHighSnd2 (x:xs) = Just $ foldr (\a b-> if snd a > snd b then a else b) x xs

findLowThd3 :: Ord c => [(a,b,c)] -> Maybe (a,b,c)
findLowThd3 [] = Nothing
findLowThd3 (x:xs) = Just $ foldr (\a b -> if (thd3 a) <= (thd3 b) then a else b ) x xs


checkFst3 :: Eq a => a -> [(a,b,c)] -> Bool
checkFst3 a list = or $ map ((a ==) . fst3) list
checkSnd3 :: Eq b => b -> [(a,b,c)] -> Bool
checkSnd3 a list = or $ map ((a ==) . snd3) list
checkThd3 :: Eq c => c -> [(a,b,c)] -> Bool
checkThd3 a list = or $ map ((a ==) . thd3) list

\end{code}



Merged stuff

\begin{code}

--stuff below should probably go into some sort of parser yModule

formatNames :: [String] -> String
formatNames [] = ""
formatNames (x:xs) = let
		counter stuff def = foldr (\a b -> if a == def then b+1 else b ) 1 stuff
		count =  counter xs x
		remaining = deleteAll x xs
	in
		(if count > 1
			then (show count) ++ " " ++ x ++ "s"
			else if (head x) `elem` upperCaseLetters
				then x
				else if (head x) `elem` vowels
					then "an " ++ x
					else "a " ++ x 
	) ++ (
		if null remaining
			then "" 
			else if null . deleteAll (head remaining) . tail $ remaining
				then ", and " 
				else ", "
		)  ++ (formatNames remaining)



upperCaseLetters :: [Char]
upperCaseLetters =
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

vowels :: [Char]
vowels =
	"aeoiuAEOIU"


\end{code}