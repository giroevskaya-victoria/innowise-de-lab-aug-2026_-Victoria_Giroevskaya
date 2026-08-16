create table Data_Layers(
	LayerID SERIAL PRIMARY KEY,
	LayerName VARCHAR(59) unique not null,
	Description text
);