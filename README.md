# Cruciverba Generator
CrossWord Generator made in Flutter, takes data from daja.json

I generated that file with an AI algorithm...

**Given N** (number of row) **and M** (number of column) **it generates a crossword grid!**
(Using a personal modified version of backtracking algorithm)

The database is populated with italian words, and definitions!
Eventualy you can translate them in english or whatever...

### Example of db record :
```javascript
{ 
    "_id":{ 
        "$oid":"5d7281eb7b2e1815b63fedf7"
    },
    "nome":"CLASSICA",
    "desc":[ 
        "La musica non leggera",
        "Si ascolta in silenzio"
    ]
}
```

```javascript
{ 
    "_id":{ 
        "$oid":"5d7281f57b2e1815b63fee35"
    },
    "nome":"CLIP",
    "desc":[ 
        "Arnese per unire fogli",
        "Breve audiovideo",
        "Chiude l'orecchino",
        "Fermaglio",
        "Fermaglio a molla",
        "Fermaglio degli orecchini",
        "Fermaglio per documenti",
        "Fermaglio per fogli",
        "Il fermaglio degli orecchini",
        "Il fermaglio della biro",
        "Piccolo fermaglio",
        "Tiene uniti fogli di carta",
        "Un breve contributo filmato",
        "Un breve filmato",
        "Un breve video",
        "Un piccolo fermaglio"
    ]
}
```


## Simple generation : 
![cruciverba img 1](https://github.com/fl0wo/cruciverba_generator/blob/master/crossword1.png)

### Complex generation : 
![cruciverba img 2](https://github.com/fl0wo/cruciverba_generator/blob/master/crossword2.png)
