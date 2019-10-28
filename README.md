# Cruciverba Generator
CrossWord Generator made in Flutter, takes data from MongoDB Atlas Cluster

Given N (number of row) and M (number of column) it generates a crossword grid!
(Using a personal modified version of backtracking algorithm)

The database is populated with italian words, and definitions!
Eventualy you can translate them in english or whatever...

### Example of db record :
```javascript
{
  "_id":{"$oid":"5d7281eb7b2e1815b63fedf7"},
  "nome":"CLASSICA",
  "desc":["La musica non leggera","Si ascolta in silenzio"]
 }
```

## Simple generation : 
![cruciverba img 1](https://github.com/fl0wo/cruciverba_generator/blob/master/crossword1.png)

### Complex generation : 
![cruciverba img 2](https://github.com/fl0wo/cruciverba_generator/blob/master/crossword2.png)
