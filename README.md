# Projet de Séminaire de Modélisation Statistique 
## ENSAE 2016

Réalisé par : Elvire Robin, Charles Cony, Guillaume Demonet.
Proposé par : Amandine Pierrot
Encadré par : Pierre Alquier

![logo-ensae](https://upload.wikimedia.org/wikipedia/commons/2/22/ENSAE_logo_developpe.jpg)

## Prévision avec les modèles _GAM_

Application aux données de la compétition *__G__lobal __E__nergy __F__orecasting __COM__petition 2014*.

### Prévision de consommation électrique

__Données fournies__
****

Sur la période __01/01/2005 00:00__ - __31/12/2011 23:00__ (et commençant au 01/01/2001 00:00 pour les températures), au pas horaire.

| Nom | Description | Type |
| --- | --- |
| `LOAD` | Consommation électrique | _float_ |
| `heure` | Heure (0-23) | _int_ |
| `date` | Date (MM/DD/YYYY) | _string_ (à convertir) |
| `w_X_` | Température à la station _X_ (de 1 à 25) | _int_ |

__Objectif__
****

Prévision au pas horaire sur l'année 2011 de `LOAD` en espérance, à l'horizon M+1, c'est-à-dire mois-à-mois (prévision de Janvier avec données jusque Décembre complet).

__Etat de la recherche__
****

Articles proposés :
+ 