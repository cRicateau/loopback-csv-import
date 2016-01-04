CREATE TABLE invoice (
    id SERIAL PRIMARY KEY,
    invoiceid integer NOT NULL,
    amount integer NOT NULL
);

CREATE TABLE fileupload (
  id SERIAL PRIMARY KEY,
  date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  filetype VARCHAR(256) NOT NULL,
  status VARCHAR(256)
);

CREATE TABLE fileuploaderror (
  id SERIAL PRIMARY KEY,
  line INTEGER,
  message VARCHAR(256) NOT NULL,
  fileuploadid INTEGER NOT NULL REFERENCES fileupload(id) ON DELETE CASCADE
);
