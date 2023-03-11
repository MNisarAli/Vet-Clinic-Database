/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-1-1' AND '2019-12-31';
SELECT name FROM animals WHERE neutered AND escape_attempts < '3';
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > '10.5';
SELECT * FROM animals WHERE neutered;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN '10.4' AND '17.3';

-- Start transaction 
BEGIN;

-- Update transaction
UPDATE animals
SET species = 'unspecified';

SELECT * FROM animals;

-- Return to previous state
ROLLBACK;

SELECT * FROM animals;

-- Start transaction
BEGIN;

-- Update transaction
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

-- Commit transaction
COMMIT;

SELECT * FROM animals;

-- Start transaction
BEGIN;

-- Delete all transactions
DELETE FROM animals;

-- Return to previous state
ROLLBACK;

SELECT * FROM animals;

-- Start transaction
BEGIN;

-- Delete transaction
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

-- Create a savepoint
SAVEPOINT savepoint1;

-- Update transaction
UPDATE animals
SET weight_kg = weight_kg * -1;

-- Return to savepoint
ROLLBACK TO savepoint1;

-- Update transaction
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

-- Commit transaction
COMMIT;

SELECT * FROM animals;

-- Count animals 
SELECT COUNT(*) FROM animals;

-- Animals that don't escape
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

-- Average weight
SELECT AVG(weight_kg) FROM animals;

-- Escapes by neutered and not neutered
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;

-- Max and Min weight of each species
SELECT species, MAX(weight_kg), MIN(weight_kg) FROM animals GROUP BY species;

-- Avg escapes per type of those born between 1990 and 2000
SELECT species, AVG(escape_attempts) FROM animals 
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

-- Animals belonging to 'Melody Pond'
SELECT animals.name FROM owners
JOIN animals ON owners.id = animals.owner_id
WHERE owners.full_name = 'Melody Pond';

-- All animals belonging to the species 'Pokemon'
SELECT animals.name FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- All animals and their corresponding owners
SELECT owners.full_name, animals.name FROM owners
LEFT JOIN animals ON animals.owner_id = owners.id;

-- Count of animals by species
SELECT species.name, COUNT(*) FROM animals
JOIN species ON species.id = animals.species_id
GROUP BY species.name;

-- Digimons owned by 'Jennifer Orwell'
SELECT animals.name FROM animals
JOIN owners ON owners.id = animals.owner_id
JOIN species ON species.id = animals.species_id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

-- Animals owned by 'Dean Winchester' that haven't tried to escape
SELECT animals.name FROM animals
JOIN owners ON owners.id = animals.owner_id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- Owner with the most animals
SELECT owners.full_name, COUNT(*) FROM owners
JOIN animals ON animals.owner_id = owners.id
GROUP BY owners.full_name ORDER BY COUNT(*) DESC
LIMIT 1;

-- Last animal seen by William 
SELECT a.name, v.date_of_visit FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'William Tatcher'
ORDER BY v.date_of_visit DESC
LIMIT 1;

-- Count of animals treated by Stephanie
SELECT COUNT(*) FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez';

-- List of vets and specialities
SELECT vt.name, s.name FROM vets vt
LEFT JOIN specializations sp ON vt.id = sp.vet_id
LEFT JOIN species s ON s.id = sp.species_id;

-- Animals that visited Stephanie between '2020-04-01' and '2020-08-30'
SELECT a.name, v.date_of_visit FROM animals a
JOIN visits v ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez'
AND v.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- Animal with the most visits
SELECT a.name, COUNT(*) FROM animals a
JOIN visits v ON a.id = v.animal_id
GROUP BY a.name 
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Maisy's first visit 
SELECT a.name, v.date_of_visit FROM vets vt
JOIN visits v ON vt.id = v.vet_id
JOIN animals a ON a.id = v.animal_id
WHERE vt.name = 'Maisy Smith'
ORDER BY v.date_of_visit
LIMIT 1;

-- Detail of most recent visit 
SELECT v.date_of_visit, vt.*, a.* FROM vets vt
JOIN visits v ON v.vet_id = vt.id
JOIN animals a ON v.animal_id = a.id
ORDER BY v.date_of_visit DESC
LIMIT 1;

-- Visits for each vet outside their specialization
SELECT vt.name, COUNT(*) FROM vets vt
JOIN visits v ON v.vet_id = vt.id
JOIN animals a ON v.animal_id = a.id
LEFT JOIN specializations sp ON sp.vet_id = vt.id
WHERE sp.species_id != a.species_id OR sp.species_id IS NULL
GROUP BY vt.name;

-- Most treated species by Maisy
SELECT s.name, COUNT(*) FROM vets vt
JOIN visits v ON v.vet_id = vt.id
JOIN animals a ON v.animal_id = a.id
JOIN species s ON a.species_id = s.id
WHERE vt.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY COUNT(*) DESC
LIMIT 1;
