use movies_database;


# Question1--Write a SQL query to find those reviewers who have rated nothing for some movies. Return reviewer name.
/*
#solution1---1 fetching reviewer name and reviewer stars by joining rating and reviewer table, as reviewer Id is common.
2- Applying condition to get the reviewer name who has rating nothing to movie.*/

select rev_stars, rev_name from rating
inner join reviewer
on reviewer.rev_id = rating.rev_id
where rating.rev_stars = 0;


#Question2- Write a SQL query to find the movies, which have been reviewed by any reviewer body except by 'Paul Monks'. Return movie title.
/*
#solution2--1 fetching reviewer name  by joining rating and reviewer table, as reviewer Id is common.
2- after joining the above details, now fetching the movie name from movie and ratimg table, as movie id is common
3- Applying condition to get the reviewer except the given reviewer name.*/


select mov_title, rev_name from reviewer
inner join rating
on reviewer.rev_id = rating.rev_id
inner join movie
on movie.mov_id = rating.mov_id
where rev_name <> 'Paul Monks';


#Question 3- Write a SQL query to find the lowest rated movies. Return reviewer name, movie title, and number of stars for those movies.

/*
#solution3---1 fetching reviewer name, number of rating  by joining rating and reviewer table, as reviewer Id is common.
2- after joining the above details, now fetching the movie name from movie and ratimg table, as movie id is common
3- Applying condition to get number of rating and get the sub-query to get the minimum number of ratings. */

select num_o_ratings, rev_name, rev_stars,mov_title from rating
inner join reviewer
on reviewer.rev_id = rating.rev_id
inner join movie
on movie.mov_id = rating.mov_id
where num_o_ratings = (select min(num_o_ratings) from rating);


#WQuestion 4- rite a SQL query to find the movies directed by 'James Cameron'. Return movie title.

/*solution4---1 fetching director name, diretor id by joining director and movie direction table, as director Id is common.
2- after joining the above details, now fetching the movie name from movie and movie director table, as movie id is common
3- Applying condition to get movie name of provided Director. */

select concat(dir_fname, ' ', dir_lname) as director_name,mov_title from director
inner join movie_direction
on movie_direction.dir_id = director.dir_id
inner join movie
on movie.mov_id = movie_direction.mov_id
where dir_fname = 'James' and 
dir_lname = 'Cameron';

#Queston 5---Write a query in SQL to find the name of those movies where one or more actors acted in two or more movies. 
/*solution5--1 fecting movie title from movie cast and movie table, as director movie id  is common.
2- after joining the above details, now fetching the actor id, actor name from movie cast and actor table, as actor id is common
3- Now using Correalted query, applying condition to get the count of actor ids who has worked for more than one movies. */

select actors.act_id, act_fname,act_lname,mov_title from movie
inner join movie_cast
on movie.mov_id = movie_cast.mov_id
inner join actors
on actors.act_id = movie_cast.act_id
where
(2 <= (select count(*) from movie_cast where movie_cast.act_id = actors.act_id));

/*
Ques 6---Given a relation R( A, B, C, D) and Functional Dependency set FD = { AB → CD, B → C }, determine whether the given R is in 2NF? If not, convert it into 2 NF.

Solution6: 
Step 1:- For a given set of FD, decompose each FD using decomposition rule (Armstrong Axiom) if the right side of any FD has more than one attribute.

FD = { AB → CD, B → C } can be decompose to
AB → C
AB → D
B → C

From above arrow diagram on R, we can see that an attributes AB is not determined by any of the given FD,
hence AB will be the integral part of the Candidate key, 

STEP 2: Now make a new set of FD having all decomposed FD.

So the new FD = {AB → C
AB → D
B → C}

STEP 3: Find closure of the left side of each of the given FD by including that FD and excluding that FD,
 if closure in both cases are same then that FD is redundant and we remove that FD from the given set,
 otherwise if both the closures are different then we do not exclude that FD.
 
Let us calculate the closure of AB

AB + = ABCD 

Since the closure of AB contains all the attributes of R, hence AB is Candidate Key

Since all key will have AB as an integral part, and we have proved that AB is Candidate Key,
Therefore, any superset of AB will be Super Key but not Candidate key.
Hence there will be only one candidate key AB

Definition of 2NF: No non-prime attribute should be partially dependent on Candidate Key

Since R has 4 attributes: - A, B, C, D, and Candidate Key is AB, Therefore, prime attributes are A and B while a non-prime attribute are C and D
a) FD: AB → CD satisfies the definition of 2NF, that non-prime attribute(C and D) are fully dependent on candidate key AB

b) FD: B → C does not satisfy the definition of 2NF, as a non-prime attribute(C) is partially dependent on candidate key AB( i.e. key should not be broken at any cost)

As FD B → C, the above table R( A, B, C, D) is not in 2NF

Convert the table R(A, B, C, D) in 2NF:
Since FD: B → C, our table was not in 2NF, let's decompose the table
R1(B, C)
Since the key is AB, and from FD AB → CD, we can create R2(A, B, C, D) but this will again have a problem of partial dependency B → C, hence R2(A, B, D).
Finally, the decomposed table which is in 2NF
a) R1( B, C)
b) R2(A, B, D)

*/

/*
Question 7 :- Given a relation R( P, Q, R, S, T, U, V, W, X, Y) and Functional Dependency set FD = { PQ → R, PS → VW, QS → TU, P → X, W → Y }, determine whether the given R is in 2NF? If not, convert it into 2 NF.

Solution 7:-

Solution:
Step 1:- For a given set of FD, decompose each FD using decomposition rule (Armstrong Axiom) if the right side of any FD has more than one attribute.

FD = { PQ → R, S → T } can be decompose to
PQ → R
S → T

From above we can see that an attributes PQS is not determined by any of the given FD,
 hence PQS will be the integral part of the Candidate key,
 i.e., no matter what will be the candidate key, and how many will be the candidate key, but all will have PQS compulsory attribute.

Let us calculate the closure of PQS

PQS + = PQSRT

Since the closure of PQS contains all the attributes of R, hence PQS is Candidate Key

From the definition of Candidate Key (Candidate Key is a Super Key whose no proper subset is a Super key)

Since all key will have PQS as an integral part, and we have proved that PQS is Candidate Key. 
Therefore, any superset of PQS will be Super Key but not Candidate key.

Hence there will be only one candidate key PQS

Definition of 2NF: No non-prime attribute should be partially dependent on Candidate Key.

Since R has 5 attributes: - P, Q, R, S, T and Candidate Key is PQS, Therefore, prime attributes (part of candidate key) are P, Q, and S while a non-prime attribute is R and T

a) FD: PQ → R does not satisfy the definition of 2NF, that non-prime attribute( R) is partially dependent on part of candidate key PQS.

b) FD: S → T does not satisfy the definition of 2NF, as a non-prime attribute(T) is partially dependent on candidate key PQS (i.e., key should not be broken at any cost).

Hence, FD PQ → R and S → T, the above table R( P, Q, R, S, T) is not in 2NF

Convert the table R( P, Q, R, S, T) in 2NF:

Since due to FD: PQ → R and S → T, our table was not in 2NF, let's decompose the table

R1(P, Q, R) (Now in table R1 FD: PQ → R is Full F D, hence R1 is in 2NF)

R2( S, T) (Now in table R2 FD: S → T is Full F D, hence R2 is in 2NF)

And create one table for the key, since the key is PQS.

R3(P, Q, S)

Finally, the decomposed tables which is in 2NF are:

a) R1( P, Q, R)

b) R2(S, T)

c) R3(P, Q, S)

*/

/*
Question 8:- Given a relation R( P, Q, R, S, T, U, V, W, X, Y) and Functional Dependency set FD = { PQ → R, PS → VW, QS → TU, P → X, W → Y }, determine whether the given R is in 2NF? If not, convert it into 2 NF.

Solution 8: For a given set of FD, decompose each FD using decomposition rule and to get the candidate key.
FD = { PQ → R, PS → VW, QS → TU, P → X, W → Y }

PQ → R,
PS → V, 
PS → W, 
QS → T,
QS → U,
P → X, 
W → Y

From above,we can see that an attributes PQS is not determined by any of the given FD,
 hence PQS will be the integral part of the Candidate key, i.e. no matter what will be the candidate key, 
 and how many will be the candidate key, but all will have PQS compulsory attribute.

Let us calculate the closure of PQS

PQS + = P Q S R T U V W X Y (from the closure )
Since the closure of PQS contains all the attributes of R, hence PQS is Candidate Key

From the definition of Candidate Key(Candidate Key is a Super Key whose no proper subset is a Super key)

Since all key will have PQS as an integral part, and we have proved that PQS is Candidate Key, 
Therefore, any superset of PQS will be Super Key but not a Candidate key.

Hence there will be only one candidate key PQS

Definition of 2NF: No non-prime attribute should be partially dependent on Candidate Key

Since R has 10 attributes: - P, Q, R, S, T, U, V, W, X, Y, and Candidate Key is PQS calculated using FD = { PQ → R, PS → VW, QS → TU, P → X, W → Y }. 
Therefore, prime attribute(part of candidate key) are P, Q, and S while non-prime attribute are R, T, U, V, W, X and Y

FD: PQ → R does not satisfy the definition of 2NF, that non-prime attribute( R) is partially dependent on part of candidate key PQS
FD: PS → VW does not satisfy the definition of 2NF, that non-prime attribute( VW) is partially dependent on part of candidate key PQS
FD: QS → TU does not satisfy the definition of 2NF, that non-prime attribute( TU) is partially dependent on part of candidate key PQS
FD: P → X does not satisfy the definition of 2NF, that non-prime attribute( X) are partially dependent on part of candidate key PQS
FD: W → Y does not violate the definition of 2NF, as the non-prime attribute(Y) is dependent on the non-prime attribute(W), which is not related to the definition of 2NF.
Hence because of FD: PQ → R, PS → VW, QS → TU, P → X the above table R( P, Q, R, S, T, U, V, W, X, Y) is not in 2NF

Convert the table R( P, Q, R, S, T, U, V, W, X, Y) in 2NF:

Since due to FD: PQ → R, PS → VW, QS → TU, P → X our table was not in 2NF, let's decompose the table

R1(P, Q, R) (Now in table R1 FD: PQ → R is Full F D, hence R1 is in 2NF)

R2( P, S, V, W) (Now in table R2 FD: PS → VW is Full F D, hence R2 is in 2NF)

R3( Q, S, T, U) (Now in table R3 FD: QS → TU is Full F D, hence R3 is in 2NF)

R4( P, X) (Now in table R4 FD : P → X is Full F D, hence R4 is in 2NF)

R5( W, Y) (Now in table R5 FD: W → Y is Full F D, hence R2 is in 2NF)

And create one table for the key, since the key is PQS.

R6(P, Q, S)

Finally, the decomposed tables which is in 2NF are:

R1(P, Q, R)

R2( P, S, V, W)

R3( Q, S, T, U)

R4( P, X)

R5( W, Y)

R6(P, Q, S)
*/

/*Question 9:- Given a relation R( X, Y, Z, W, P) and Functional Dependency set FD = { X → Y, Y → P, and Z → W}, determine whether the given R is in 3NF? If not, convert it into 3 NF.


For a given set of FD, decompose each FD using decomposition rule and to get the candidate key.
FD = { X → Y, Y → P, and Z → W}
 X → Y, 
 Y → P,
 Z → W
From above, we can see that an attributes XZ is not determined by any of the given FD,
 hence XZ will be the integral part of the Candidate key, i.e. no matter what will be the candidate key,
 and how many will be the candidate key, but all will have XZ compulsory attribute.

Let us calculate the closure of XZ

XZ + = XZYPW 

Since the closure of XZ contains all the attributes of R, hence XZ is Candidate Key

From the definition of Candidate Key (Candidate Key is a Super Key whose no proper subset is a Super key).

Since all key will have XZ as an integral part, and we have proved that XZ is Candidate Key, Therefore, any superset of XZ will be Super Key but not the Candidate key.

Hence there will be only one candidate key XZ

Definition of 3NF: First it should be in 2NF and if there exists a non-trivial dependency between two sets of attributes X and Y such that X → Y ( i.e., Y is not a subset of X) then

Either X is Super Key
Or Y is a prime attribute.
Since R has 5 attributes: - X, Y, Z, W, P and Candidate Key is XZ, Therefore, prime attribute (part of candidate key) are X and Z while a non-prime attribute are Y, W, and P

Given FD are X → Y, Y → P, and Z → W and Super Key / Candidate Key is XZ

FD: X → Y does not satisfy the definition of 3NF, that neither X is Super Key nor Y is a prime attribute.
FD: Y → P does not satisfy the definition of 3NF, that neither Y is Super Key nor P is a prime attribute.
FD: Z → W satisfies the definition of 3NF, that neither Z is Super Key nor W is a prime attribute.
Convert the table R( X, Y, Z, W, P) into 3NF:

Since all the FD = { X → Y, Y → P, and Z → W} were not in 3NF, let us convert R in 3NF

R1(X, Y) {Using FD X → Y}

R2(Y, P) {Using FD Y → P}

R3(Z, W) {Using FD Z → W}

And create one table for Candidate Key XZ

R4( X, Z) { Using Candidate Key XZ }

All the decomposed tables R1, R2, R3, and R4 are in 2NF( as there is no partial dependency) as well as in 3NF.

Hence decomposed tables are:

R1(X, Y), R2(Y, P), R3( Z, W), and R4( X, Z)*/

/*Question 10:- Given a relation R( P, Q, R, S, T, U, V, W, X, Y) and Functional Dependency set FD = { PQ → R, P → ST, Q → U, U → VW, and S → XY},
 determine whether the given R is in 3NF? If not convert it into 3 NF.


Solution 10 : Let us construct an arrow diagram on R using FD to calculate the candidate key.
For a given set of FD, decompose each FD using decomposition rule and to get the candidate key.
 PQ → R, 
 P → S,
 P → T,
 Q → U,
 U → V,
 U → W,
 S → X
S → Y

From above we can see that an attribute PQ is not determined by any of the given FD, hence PQ will be the integral part of the Candidate key, i.e. no matter what will be the candidate key, and how many will be the candidate key, but all will have PQ compulsory attribute.

Let us calculate the closure of PQ

PQ + = P Q R S T U X Y V W (from the closure method we studied earlier)

Since the closure of XZ contains all the attributes of R, hence PQ is Candidate Key

From the definition of Candidate Key (Candidate Key is a Super Key whose no proper subset is a Super key)

Since all key will have PQ as an integral part, and we have proved that XZ is Candidate Key, Therefore, any superset of PQ will be Super Key but not Candidate key.

Hence there will be only one candidate key PQ

Definition of 3NF: First it should be in 2NF and if there exists a non-trivial dependency between two sets of attributes X and Y such that X → Y (i.e., Y is not a subset of X) then

c) Either X is Super Key

d) Or Y is a prime attribute.

Since R has 10 attributes: - P, Q, R, S, T, U, V, W, X, Y, V, W and Candidate Key is PQ, Therefore, prime attribute (part of candidate key) are P and Q while a non-prime attribute are R S T U V W X Y V W

Given FD are {PQ → R, P → ST, Q → U, U → VW and S → XY} and Super Key / Candidate Key is PQ

FD: PQ → R satisfy the definition of 3NF, as PQ Super Key
FD: P → ST does not satisfy the definition of 3NF, that neither P is Super Key nor ST is the prime attribute
FD: Q → U does not satisfy the definition of 3NF, that neither Q is Super Key nor U is a prime attribute
FD: U → VW does not satisfy the definition of 3NF, that neither U is Super Key nor VW is a prime attribute
FD: S → XY does not satisfy the definition of 3NF, that neither S is Super Key nor XY is a prime attribute
Convert the table R( X, Y, Z, W, P) into 3NF:

Since all the FD = { P → ST, Q → U, U → VW, and S → XY } were not in 3NF, let us convert R in 3NF

R1(P, S, T) {Using FD P → ST }

R2(Q, U) {Using FD Q → U }

R3( U, V, W) { Using FD U → VW }

R4( S, X, Y) { Using FD S → XY }

R5( P, Q, R) { Using FD PQ → R, and candidate key PQ }

All the decomposed tables R1, R2, R3, R4, and R5 are in 2NF( as there is no partial dependency) as well as in 3NF.

Hence decomposed tables are:

R1(P, S, T), R2(Q, U), R3(U, V, W), R4( S, X, Y), and R5( P, Q, R) 
*/