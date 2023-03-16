CREATE TABLE "specializations"(
    "vet_id" INTEGER NULL,
    "species_id" INTEGER NULL
);
ALTER TABLE
    "specializations" ADD PRIMARY KEY("vet_id", "species_id");
CREATE TABLE "owners"(
    "id" INTEGER NULL,
    "full_name" VARCHAR(255) NOT NULL,
    "age" INTEGER NOT NULL,
    "email" VARCHAR(255) NULL
);
ALTER TABLE
    "owners" ADD PRIMARY KEY("id");
CREATE INDEX "owners_email_index" ON
    "owners"("email");
CREATE TABLE "visits"(
    "animal_id" INTEGER NULL,
    "vet_id" INTEGER NULL,
    "date_of_visit" DATE NULL
);
ALTER TABLE
    "visits" ADD PRIMARY KEY(
        "animal_id",
        "vet_id",
        "date_of_visit"
    );
CREATE INDEX "visits_animal_id_index" ON
    "visits"("animal_id");
CREATE INDEX "visits_vet_id_index" ON
    "visits"("vet_id");
CREATE TABLE "vets"(
    "id" INTEGER NULL,
    "name" VARCHAR(255) NULL,
    "age" INTEGER NULL,
    "date_of_graduation" DATE NULL
);
ALTER TABLE
    "vets" ADD PRIMARY KEY("id");
CREATE TABLE "animals"(
    "id" INTEGER NULL,
    "name" VARCHAR(255) NOT NULL,
    "date_of_birth" DATE NOT NULL,
    "escape_attempts" INTEGER NULL,
    "neutered" BOOLEAN NULL,
    "weight_kg" DECIMAL(8, 2) NOT NULL,
    "species_id" INTEGER NULL,
    "owner_id" INTEGER NULL
);
ALTER TABLE
    "animals" ADD PRIMARY KEY("id");
CREATE TABLE "species"(
    "id" INTEGER NULL,
    "name" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "species" ADD PRIMARY KEY("id");
ALTER TABLE
    "visits" ADD CONSTRAINT "visits_vet_id_foreign" FOREIGN KEY("vet_id") REFERENCES "vets"("id");
ALTER TABLE
    "visits" ADD CONSTRAINT "visits_animal_id_foreign" FOREIGN KEY("animal_id") REFERENCES "animals"("id");
ALTER TABLE
    "specializations" ADD CONSTRAINT "specializations_vet_id_foreign" FOREIGN KEY("vet_id") REFERENCES "species"("id");
ALTER TABLE
    "animals" ADD CONSTRAINT "animals_owner_id_foreign" FOREIGN KEY("owner_id") REFERENCES "owners"("id");
ALTER TABLE
    "animals" ADD CONSTRAINT "animals_species_id_foreign" FOREIGN KEY("species_id") REFERENCES "species"("id");
ALTER TABLE
    "specializations" ADD CONSTRAINT "specializations_vet_id_foreign" FOREIGN KEY("vet_id") REFERENCES "vets"("id");