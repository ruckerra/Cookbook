/*NOTE: MASTER SCRIPT :: START OF FILE*/
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS users_ep;
DROP TABLE IF EXISTS users_ue;
DROP TABLE IF EXISTS users_recipes;
DROP TABLE IF EXISTS users_favorites;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS nutrition;
DROP TABLE IF EXISTS recipes;

CREATE TABLE users(
	user_uid UUID NOT NULL PRIMARY KEY,
	first_name VARCHAR(25) NOT NULL,
	last_name VARCHAR(25) NOT NULL,
	username VARCHAR(30) NOT NULL,
	date_reg DATE NOT NULL, /*NOW()::DATE*/
	verified BOOLEAN,
	user_image_path TEXT,
	UNIQUE(username)
);

CREATE TABLE users_ue(
	username VARCHAR(30) NOT NULL,
	email VARCHAR(50) NOT NULL,
	UNIQUE(username),
	UNIQUE(email),
	CONSTRAINT users_ue_pkey
		PRIMARY KEY (username),
	CONSTRAINT users_ue_fpkey
		FOREIGN KEY (username) REFERENCES users(username)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
	CONSTRAINT email_format
		CHECK (email LIKE '%@%.%')
);

CREATE TABLE users_ep(
	email VARCHAR(50) NOT NULL,
	password VARCHAR(20),
	UNIQUE(email),
	CONSTRAINT users_ep_pkey
		PRIMARY KEY (email),
	CONSTRAINT users_ep_fpkey
		FOREIGN KEY (email) REFERENCES users_ue(email)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE TABLE recipes(
	recipe_id BIGSERIAL NOT NULL PRIMARY KEY, /*Use negative values to see recipes waiting to be approved*/
	recipe_name VARCHAR(75) NOT NULL,
	prep_time INT NOT NULL,
	total_time INT NOT NULL,
	vegetarian BOOLEAN NOT NULL,
	vegan BOOLEAN NOT NULL,
	gluten_free BOOLEAN NOT NULL,
	denomination VARCHAR(10) NOT NULL,
	notes TEXT,
	recipe_image_path TEXT,
  ingredients TEXT[] NOT NULL,
	directions TEXT[] NOT NULL,
	UNIQUE(recipe_name),
	CONSTRAINT recipe_denomination
		CHECK (denomination = 'breakfast' OR denomination = 'brunch'
			OR denomination = 'lunch' OR denomination = 'dinner'
			OR denomination = 'linner' OR denomination = 'snack'
			OR denomination = 'dessert' OR denomination = 'appetizer'
			OR denomination = 'side' OR denomination = 'other')
);

CREATE TABLE nutrition(
	recipe_name VARCHAR(75) NOT NULL,
	calories INT NOT NULL,
	fat INT NOT NULL,
	carbs INT NOT NULL,
	fiber INT NOT NULL,
	protien INT NOT NULL,
	servings INT,
	notes TEXT,
	UNIQUE(recipe_name),
	CONSTRAINT nutrition_pkey
		PRIMARY KEY (recipe_name),
	CONSTRAINT nutrition_fpkey
		FOREIGN KEY (recipe_name) REFERENCES recipes(recipe_name)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE TABLE users_recipes(
	username VARCHAR(30),
	recipe_id BIGINT NOT NULL,
	CONSTRAINT users_recipes_username_fkey
		FOREIGN KEY (username) REFERENCES users(username)
			ON UPDATE CASCADE
			ON DELETE SET NULL,
	CONSTRAINT users_recipes_recipe_id_fkey
		FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE TABLE users_favorites(
	user_uid UUID NOT NULL,
	recipe_id BIGINT NOT NULL,
	CONSTRAINT users_favorites_user_uid_fkey
		FOREIGN KEY (user_uid) REFERENCES users(user_uid)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
	CONSTRAINT users_favorites_recipe_id_fkey
		FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

/*ON CONFLICT (user_uid) DO UPDATE SET EXCLUDED.user_uid = uuid_generate_v4();*/




INSERT INTO users(user_uid, first_name, last_name, username, date_reg, verified)
	VALUES('8a94964b-fb4f-4801-8426-ff7ba6496481', 'Fun', 'Guy', 'Operator', NOW()::DATE, TRUE);
INSERT INTO users_ue(username, email)
	VALUES('Operator', 'throwaway@doge.wow');
INSERT INTO users_ep(email, password)
	VALUES('throwaway@doge.wow', '0$O&e&AtN(S&fa1KY%77');


INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Anabolic Apple Pie Breakfast Bake',
20,
60,
'{
"MAKES 1 BATCH. SERVING SIZE VARIES DEPENDING ON HOW LARGE OR SMALL YOU CUT THE PIECES.",
"18 slices regular  bread (or one loaf [570g] of regular  bread)",
"1920g (4 cartons/2000ml) egg whites",
"21g (3 tbsp) cinnamon",
"15g (1 tbsp) vanilla extract",
"15 packets (5⁄8 cup) sweetener",
"1500g or ~10 apples of your choice",
"Cooking spray"
}',
'{
"Pre-heat the oven to 400°F (204°C).",
"Chop the apples into small pieces.",
"In a bowl, whisk egg whites, cinnamon, sweetener, and vanilla.",
"Tear the bread into small pieces and place in a bowl with the egg whites, cinnamon, sweetener, and vanilla. Mix with your hands until the bread pieces are well soaked with the batter.",
"Spray a casserole dish with cooking spray for 1 second. Pour the egg white/bread mixture into the casserole dish.",
"Place the casserole dish uncovered in the middle rack and cook in the oven at 400°F/204°C for 40-50 minutes."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
270,
1,
37,
4,
22,
12
);
INSERT INTO users_recipes(username,recipe_id)
  SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
  WHERE NOT EXISTS (
    SELECT username, recipe_id FROM users_recipes
      WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
  );





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Anabolic French Toast',
10,
20,
'{
"MAKES 1 SERVING",
"180g (3⁄4 cup) egg whites",
"2 slices regular  bread (up to 80 calories per slice)",
"2 packets (~1 tbsp) sweetener",
"1 tsp cinnamon",
"5g (1 tsp) vanilla extract",
"Cooking spray",
"TOP WITH:",
"60ml (4 tbsp) low-calorie syrup (20 calories)"
}',
'{
"In a bowl, add egg whites, sweetener, cinnamon, and vanilla extract. Whisk until spices are evenly distributed throughout the mixture.",
"Heat a griddle over low-medium heat. Spray griddle with cooking spray.",
"Dip bread slices into egg white mixture, and transfer to pan.",
"Spoon any leftover egg white mixture on to the bread in the pan. If done slowly, the bread should absorb the mixture and get fluffy.",
"Let cook for about 3-4 minutes on each side.",
"Remove French toast from the pan and serve on a plate with toppings. Suggestions for toppings are fresh fruit and low-calorie syrup."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
270,
1,
30,
6,
28,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
  SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
  WHERE NOT EXISTS (
    SELECT username, recipe_id FROM users_recipes
      WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
    );




INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Banana French Toast Roll-Ups',
10,
20,
'{
"MAKES 2 ROLL-UPS (1 SERVING)",
"FILLING:",
"30g banana",
"8g (1⁄4 scoop) chocolate peanut butter protein powder",
"2.5g (1⁄2 tbsp) cocao powder",
"15ml (1 tbsp) water",
"FRENCH TOAST BASE:",
"2 slices regular  bread (up to 80 cal per slice)",
"120g (1⁄2 cup) egg whites",
"2 packets (4 tsp) sweetener",
"1⁄2 tsp cinnamon",
"1⁄4 tsp vanilla extract",
"Cooking spray",
"TOPPINGS:",
"3g (1⁄2 tbsp) powdered peanut butter (PB2)",
"40g strawberries",
"30ml (2 tbsp) sugar-free syrup (10 calories)"
}',
'{
"In a bowl, mix the filling ingredients with a fork or whisk until a thick & uniform paste is formed.",
"Spread the paste onto the slices of regular  bread, and add the sliced banana on top.",
"Roll up the bread and pinch around the edges to seal in the filling (like a burrito).",
"Whisk egg whites, cinnamon and vanilla extract into a bowl until fully mixed.",
"Heat a pan over medium heat, and spray with cooking spray.",
"Once the pan has achieved medium heat, submerge the sealed bread pockets into the egg white/cinnamon/vanilla extract mixture.",
"Remove and place onto the pan until the egg whites are fully cooked.",
"Remove from the pan and plate with optional toppings of powdered peanut butter (either mixed with water or dry), strawberries, and sugar-free syrup. Serve and enjoy!"
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
340,
4,
54,
5,
28,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
  	SELECT username, recipe_id FROM users_recipes
    	WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Blueberry French Toast',
10,
20,
'{
"MAKES 1 SERVING",
"180g (3⁄4 cup) egg whites",
"2 slices regular  bread (up to 80 calories per slice)",
"60g blueberries",
"2 packets (4 tsp) sweetener",
"1⁄2 tsp cinnamon",
"3g (~1⁄2 tsp) vanilla extract",
"Cooking spray",
"RECOMMENDED TOPPINGS:",
"60ml (4 tbsp) low-calorie syrup (20 calories)"
}',
'{
"In a bowl, add egg whites, sweetener, cinnamon, and vanilla extract. Whisk until spices are evenly distributed throughout the mixture.",
"Heat a griddle over low-medium heat. Spray griddle with cooking spray. Place blueberries on the stove while the pan is heating up.",
"Dip bread slices into egg white mixture, and transfer to pan, placing the bread directly on top of the cooked blueberries.",
"Spoon any leftover egg white mixture into the bread in the pan. If done slowly, the bread should absorb the mixture and get fluffy.",
"Let cook for about 3-4 minutes on each side.",
"Remove blueberry French toast from the pan and serve on a plate with toppings. Suggestions for toppings are extra fruit and low-calorie syrup."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
310,
3,
47,
3,
24,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
  	SELECT username, recipe_id FROM users_recipes
    	WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Peach French Toast Bake',
15,
60,
'{
"MAKES 1 BATCH. SERVING SIZE VARIES DEPENDING ON HOW LARGE OR SMALL YOU CUT THE PIECES.",
"18 slices regular  bread (or one loaf [570g] of regular  bread)",
"1440g (3 cartons) egg whites",
"21g (3 tbsp) cinnamon",
"15g (1 tbsp) vanilla extract",
"15 packets (5⁄8 cup) sweetener",
"1500g (~10) nectarines or peaches, frozen or fresh, IT DOESN''T MATTER"
}',
'{
"Pre-heat the oven to 400°F (204°C).",
"Cut the nectarines/peaches into small pieces.",
"In a bowl, whisk egg whites, cinnamon, sweetener, and vanilla.",
"Tear the bread into small pieces and place in a bowl with the egg whites, cinnamon, sweetener, and vanilla. Mix with your hands until the bread pieces are well soaked with the batter.",
"Spray a casserole dish for 1 second. Pour the egg white/bread mixture into the casserole dish.",
"Place the casserole dish uncovered in the middle rack and cook in the oven at 400°F/204°C for 40-50 minutes."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
235,
2,
37,
4,
19,
12
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
  	SELECT username, recipe_id FROM users_recipes
    	WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Protein Bread French Toast',
10,
20,
'{
"MAKES 2 SERVINGS",
"120g (1⁄2 cup) egg whites",
"2 slices ICON Meals protein bread OR protein bread of choice (140 calories per slice)",
"1 packet (2 tsp) sweetener",
"1 tsp cinnamon",
"5g (1 tsp) vanilla extract",
"Cooking spray",
"TOP WITH:",
"60ml (4 tbsp) low-calorie syrup (20 calories)"
}',
'{
"In a bowl, add egg whites, sweetener, cinnamon, and vanilla extract. Whisk until spices are evenly distributed throughout the mixture.",
"Heat a griddle over low-medium heat. Spray griddle with cooking spray.",
"Dip bread slices into egg white mixture, and transfer to pan.",
"Spoon any leftover egg white mixture into the bread in the pan. If done slowly, the bread should absorb the mixture and get fluffy.",
"Let cook for about 3-4 minutes on each side.",
"Remove French toast from the pan and serve on a plate with toppings. Suggestions for toppings are fresh fruit and low-calorie syrup."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
190,
5,
20,
2,
22,
2
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
  	SELECT username, recipe_id FROM users_recipes
    	WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Egg White Avocado Rice Cakes',
10,
15,
'{
"MAKES 3 RICE CAKES",
"3 rice cakes",
"60g avocado",
"90g sliced tomato",
"40g chopped onion",
"40g chopped tomato",
"240g (1 cup) egg whites of choice (I prefer chedder and chive)",
"1 tbsp minced garlic",
"1 tsp paprika",
"1 tbsp lemon juice (desired taste)",
"Salt (desired taste)",
"Cooking spray"
}',
'{
"In a medium bowl, mash up avocado to make it into a paste. Add the chopped tomato, paprika, minced garlic, lemon juice, salt & pepper, and mix.",
"Heat a pan over medium-high heat. Spray with cooking spray for 1 second. Place three egg rings on the skillet and place the egg whites in the egg rings. NOTE: If you don''t have egg rings, simply place the egg whites in the pan, cook and flip, then divide it into 3 pieces for each rice cake.",
"Lay the 3 rice cakes on a plate. Stack each rice cake with one of the egg white circles cooked in the egg white rings.",
"Divide the avocado mash and place on top of the egg white rings. Add sliced tomato on top.",
"Serve as three open-face pieces of rice cake deliciousness. You may add fresh-squeezed lemon and cracked pepper if desired."
}',
FALSE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
133,
3,
17,
3,
10,
3
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Egg White Avocado Toast',
10,
15,
'{
"MAKES 1 SERVING",
"2 slices regular  bread",
"60g avocado",
"90g sliced tomato",
"40g chopped onion",
"40g chopped tomato",
"240g (1 cup) egg whites of choice",
"1 tbsp minced garlic (or 3 cloves, minced)",
"1 tsp paprika",
"1 tsp lemon juice",
"Salt & pepper (to taste)"
}',
'{
"In medium bowl, mash up avocado making it into a paste. Add the chopped tomato, paprika, minced garlic, lemon juice, and salt & pepper, and mix.",
"Place the bread slices in the toaster.",
"Heat a pan over medium-high heat. Spray with cooking spray for 1 second. Cook the egg whites in the pan. Remove from the pan and divide the cooked egg whites on the open-face toast.",
"Remove the toast from the toaster and place on a plate. Divide the avocado mash and place on both slices, adding sliced tomato on top.",
"Serve as two open-face pieces of toast deliciousness. Serve with fresh-squeezed lemon and cracked pepper if desired."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
430,
12,
54,
14,
35,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Egg White Bites',
10,
25,
'{
"MAKES 1 SERVING",
"480g (2 cups) egg whites",
"100g spinach leaves",
"100g tomato, diced (~20 calories)",
"4 slices fat-free cheese (or 76g shredded fat-free cheese)",
"Salt & pepper (to taste)"
}',
'{
"Preheat the oven to 400°F/204°C.",
"In a bowl, whisk the egg whites, cheese, salt and pepper together well.",
"Spray a non-stick muffin pan with cooking spray.",
"Stuff the spinach evenly into each muffin mold. Then place the tomatoes in each hole on top of the spinach. Carefully fill up each hole with the egg white mixture to the top until used up.",
"Bake the egg white cups in the oven for 10 minutes or until fully cooked. Remove from the oven and use a fork to carefully pull them from the muffin tin. Transfer to a plate and serve."
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
410,
1,
23,
4,
72,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Fire-Roasted Veggie Omelette',
30,
40,
'{
"MAKES 1 SERVING",
"300g (11⁄4 cup) egg whites",
"25g red bell peppers, julienned/cut into thin strips",
"25g yellow onion, julienned/cut into thin strips",
"50g cherry tomatoes",
"50g yellow squash, sliced",
"50g zucchini, sliced",
"50g button mushrooms, sliced",
"50g fresh spinach",
"56g crumbled reduced-fat feta cheese (or low-fat cheese of choice for up to 120 calories)",
"Salt & pepper (to taste)"
}',
'{
"Pre-heat the oven to 400°F/204°C.",
"In a bowl, mix all the vegetables together, except for the spinach. Spray them lightly with cooking spray and season lightly with salt and pepper. Place the mix on a baking sheet and bake in the oven at 400°F/204°C for 10 minutes. Remove from the oven and set aside.",
"In a bowl, whisk the egg whites well. Add the roasted vegetables and the remaining ingredients and mix well.",
"Heat the stovetop to medium heat. Using a nonstick skillet, add the egg mixture and cook on one side for 3 minutes or until the egg whites are partially cooked. Make sure to work the egg mixture back and forth with a rubber spatula so they don''t stick to the pan.",
"When ready, flip, turn or roll the omelette over and cook for an additional 2 minutes.",
"Once it is fully cooked, fold the omelette in half and serve."
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
340,
10,
17,
5,
46,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Ham & Cheese Omelette',
15,
20,
'{
"MAKES 2 SERVINGS",
"480g (2 cups) egg whites",
"100g lean deli ham, diced",
"1 serving veggies up to 100 calories (bell peppers, spinach, tomatoes, yellow onions)",
"4 slices (or 76g shredded) fat-free cheese (120 calories)",
"Salt & Pepper to taste",
"4 tbsp of your favorite salsa OR 2 tbsp no sugar-added ketchup"
}',
'{
"In a bowl, whisk the egg whites well. Add all the remaining ingredients (except for the cheese) and mix well.",
"Heat the stove to medium heat. Using a nonstick skillet, spray with cooking spray then add the egg mixture and cook on one side for 3 minutes or until the egg whites are partially cooked.",
"Add half the cheese and fold over in half and cook for 2 min on low heat.",
"Then when ready, flip, turn or roll the omelette over and cook for an additional 2 minutes with remaining cheese slices on top to melt.",
"Once it is fully cooked, serve with salsa on top or on the side."
}',
FALSE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
295,
2,
22,
5,
44,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Ham, Spinach and Feta Omelette',
15,
20,
'{
"MAKES 1 OMELET",
"110g ham, diced",
"150g (5⁄8 cup) egg whites",
"100g spinach leaves",
"100g tomato, diced",
"14g crumbled reduced fat feta cheese (30 calories)",
"Salt & pepper to taste"
}',
'{
"In a non-stick skillet, steam the spinach with a little bit of water till the spinach wilts. Drain off the excess water and set aside.",
"In a bowl, whisk the egg whites well. Add all the remaining ingredients, including the steamed spinach and mix well.",
"Heat the stovetop to medium heat. Using a nonstick skillet, add the egg mixture and cook on one side for 3 minutes or until the egg whites are partially cooked. Make sure to work the egg mixture back and forth with a rubber spatula so they don''t stick to the pan.",
"When ready, flip, turn or roll the omelette over and cook for an additional 2 minutes.",
"Once it is fully cooked, fold the omelette in half and serve."
}',
FALSE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
265,
6,
12,
3,
41,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Tex Mex Omelette',
15,
20,
'{
"MAKES 1 OMELET",
"110g (4 oz) 95% extra lean ground beef, measurered raw",
"150g (5⁄8 cup) egg whites",
"1 whole egg",
"2 slices (or 38g shredded) fat-free cheese (60 calories)",
"110g tomato, diced",
"60g yellow onion, diced",
"60g red bell pepper, diced",
"10g (~2 tbsp) green onion, diced",
"Spices to taste:",
"salt, pepper, chili powder, ground cumin",
"Optional toppings:",
"3 tbsp salsa",
"3 tbsp fat-free sour cream"
}',
'{
"In a non-stick skillet, cook the ground beef completely, then drain off the excess fat. Set aside to cool.",
"In a bowl, whisk the egg whites well. Add all the remaining ingredients (except the toppings) and mix well.",
"Heat the stovetop to medium heat. Using a nonstick skillet, add the egg mixture and cook on one side for 3 minutes or until the egg whites are partially cooked. Make sure to work the egg mixture back and forth with a rubber spatula so they don''t stick to the pan.",
"Then when ready, flip, turn or roll the omelette over and cook for an additional 2 minutes.",
"Once it is fully cooked, fold the omelette in half and put on the plate. Serve with optional toppings of salsa and fat-free sour cream."
}',
FALSE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
415,
8,
28,
5,
53,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Whole Egg Avocado Toast',
10,
15,
'{
"MAKES 1 SERVING",
"2 slices regular  bread",
"60g avocado",
"90g sliced tomato",
"40g chopped onion",
"40g chopped tomato",
"180g (3⁄4 cup) egg whites",
"1 tbsp minced garlic (or 3 cloves, minced)",
"1 tsp paprika",
"1 tsp lemon juice",
"Salt & pepper (to taste)"
}',
'{
"In medium bowl, mash up avocado making it into a paste. Add the chopped tomato, paprika, minced garlic, lemon juice, and salt & pepper, and mix.",
"Place the bread slices in the toaster.",
"Heat a pan over medium-high heat. Spray with cooking spray for 1 second. Cook the egg whites in the pan. Remove from the pan and divide the cooked egg whites on the open-face toast.",
"Remove the toast from the toaster and place on a plate. Divide the avocado mash and place on both slices, adding sliced tomato on top.",
"Serve as two open-face pieces of toast deliciousness. Serve with fresh-squeezed lemon and cracked pepper if desired."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
550,
21,
50,
10,
44,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Berries N'' Cream Crepe',
10,
20,
'{
"MAKES 2 CREPES (1 SERVING)",
"2 Crepini Egg White Wraps (or equivalent egg white wrap)",
"FILLING:",
"11g (1⁄3 scoop) protein powder of choice",
"2.5g (1⁄2 tbsp) cocoa powder",
"1⁄4 packet (1⁄2 tsp) sweetener",
"60g (1⁄4 cup) 0% fat Greek yogurt",
"45g (1⁄4 serving) blueberries",
"TOPPINGS:",
"3g (1⁄2 tbsp) powdered peanut butter (PB2)",
"5g (1 tbsp) cocoa powder",
"Water to desired thickness (~1⁄2 tbsp)",
"6-7 (~75g) strawberries"
}',
'{
"Lay the crepes out flat.",
"In a bowl, make the filling by mixing the protein powder, cocoa, sweetener, and Greek yogurt until well mixed.",
"Divide the filling up evenly to fill each crepe and spread on one quarter of the far side of each crepe.",
"Once the filling is placed onto the crepes, cut up your choice of fruit, divide, and place on top of filling on each crepe.",
"Take the end with the filling side and start rolling the crepes. Fold in both sides as you are rolling the crepe to secure the filling inside.",
"Once all rolled, spray a frying pan with cooking spray and turn on medium heat.",
"Set each rolled crepe on the pan and let cook until crepe starts to crisp then flip and crisp the other side.",
"While crepes are cooking, heat the rest of the fruit in the microwave for around 20-30 seconds.",
"Mix the peanut butter powder and cocoa powder with water to desired thickness.",
"Once crepes are done, place them on a plate and top them with the heated fruit and the peanut-cocoa drizzle, ENJOY."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
210,
5,
19,
5,
22,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Fruity Crepes',
10,
20,
'{
"MAKES 2 CREPES (1 SERVING)",
"2 Crepini Egg White Wraps (or equivalent egg white wraps)",
"FILLING:",
"11g (1⁄3 scoop) protein powder",
"2.5g (1⁄2 tbsp) cocoa powder",
"Water to desired thickness (~1 tbsp)",
"1⁄4 packet (1⁄2 tsp) sweetener",
"3-4 strawberries (~40g)",
"30g banana",
"TOPPINGS:",
"3g (1⁄2 tbsp) powdered peanut butter (PB2)",
"2.5g (1⁄2 tbsp) cocoa powder",
"Water to desired thickness (~1⁄2 tbsp)",
"3-4 strawberries (~40g)"
}',
'{
"Lay the crepes out flat.",
"In a bowl, make the filling by mixing the protein powder, cocoa, sweetener, and water until well mixed.",
"Divide the filling up evenly to fill each crepe and spread on one quarter of the far side of each crepe.",
"Once the filling is placed onto the crepes, cut up your choice of fruit, divide, and place on top of filling on each crepe.",
"Take the end with the filling side and start rolling the crepes. Fold in both sides as you are rolling the crepe to secure the filling inside.",
"Once all rolled, spray a frying pan with cooking spray and turn on medium heat.",
"Set each rolled crepe on the pan and let cook until crepe starts to crisp then flip and crisp the other side.",
"While crepes are cooking, take the rest of the fruit and heat up in microwave for around 20-30 seconds.",
"Mix the peanut butter powder and cocoa powder with water to desired thickness.",
"Once crepes are done, place them on a plate and top them with the heated fruit and the peanut-cocoa drizzle, ENJOY."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
180,
5,
17,
4,
17,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Apple Protein Pancakes',
10,
20,
'{
"MAKES 5 PANCAKES",
"480g (2 cups) egg whites",
"65g (3⁄4 cup) rolled oats",
"125g (1⁄2 cup) 0% fat cottage cheese",
"450g (1 lb) apples",
"11⁄2 tsp cinnamon",
"5 packets (~3 tbsp) sweetener",
"6g (2 tsp) guar gum",
"5g (1 tsp) baking powder",
"TOP WITH:",
"60ml (4 tbsp) low-calorie syrup (20 calories)"
}',
'{
"Place the rolled oats in a Ninja blender (or whatever blender you own!) and pulse until it is a powdery consistency.",
"Add the remaining ingredients into the blender, and blend on high for 30 seconds or until a uniform consistency is achieved.",
"(OPTIONAL) Transfer blended mixture to an airtight container, and let sit in refrigerator for 4 hours. (Note: these can be eaten right away, but it is preferable to let the batter thicken over a few hours).",
"Heat a griddle over low-medium heat. Spray griddle with cooking spray. Add mixture to griddle and let sit for 1-2 minutes until edges appear cooked through.",
"Flip pancake with a spatula, and let sit for another 30-60 seconds, depending on doneness.",
"Remove pancake from the griddle and serve on a plate with toppings of choice."
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
165,
2,
25,
4,
15,
5
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Banana Chocolate Pancakes',
10,
15,
'{
"MAKES 4 PANCAKES",
"180g (3⁄4 cup) egg whites",
"220g ripe banana",
"33g (1 scoop) chocolate protein powder (130 calories, 25g protein)",
"65g (3⁄4 cup) rolled oats",
"15g (3 tbsp) cocoa powder",
"1 tsp cinnamon",
"Cooking spray",
"TOP WITH:",
"60ml (4 tbsp) low-calorie syrup (20 calories)"
}',
'{
"Place rolled oats into a blender, and blend on high until the oats are powdery.",
"Add the remaining dry ingredients (protein powder, cinnamon, and cocoa powder) to the blender, and pulse until well-mixed.",
"Add the liquid ingredients to the blender, and blend on medium until the batter is smooth.",
"Heat a skillet over medium-high heat. Spray the pan with cooking spray, and add the batter to the pan to form a pancake.",
"Allow to cook on one side for 2-4 minutes or until the edges start to appear cooked, and then flip.",
"Remove from the pan and serve. Repeat until you''ve cooked as many pancakes as you want. (You may also store the extra batter and cook it later, or cook the extra pancakes now, and refrigerate until you are ready to eat them.)"
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
180,
2,
27,
4,
15,
4
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Banana Protein Pancakes',
10,
15,
'{
"MAKES 5 PANCAKES",
"480g (2 cups) egg whites",
"330g ripe banana",
"65g (3⁄4 cup) rolled oats",
"125g (1⁄2 cup) 0% fat cottage cheese",
"1⁄2 tbsp cinnamon",
"5 packets (3 tbsp) sweetener",
"6g (2 tsp) guar gum",
"4g (1 tsp) baking powder",
"1 tsp cinnamon",
"Cooking spray",
"RECOMMENDED TOPPINGS:",
"60ml (4 tbsp) low-calorie syrup (20 calories)"
}',
'{
"Blend all ingredients for 30 seconds or until a uniform consistency is achieved.",
"(OPTIONAL) Transfer blended mixture to an airtight container, and let sit in refrigerator for 4 hours. (Note: these can be eaten right away, but it is preferable to let the batter thicken over a few hours).",
"Heat a griddle over low-medium heat. Spray griddle with cooking spray. Add mixture to griddle and let sit for 1-2 minutes until edges appear cooked through.",
"Remove pancake from the griddle and serve on a plate with toppings of choice."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
180,
1,
27,
3,
15,
5
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Cheese & Chive Cauliflower Protein Pancakes',
15,
30,
'{
"MAKES 6 PANCAKES",
"300g cauliflower",
"90g (1 cup) rolled oats",
"480g (2 cups) Cheddar and Chives fat-free egg whites or other flavoured egg whites such as Garden Vegetable or Tex Mex",
"33g (1 scoop) casein protein powder (vanilla)",
"3g (1 tsp) guar/xanthan gum",
"2 packets (4 tsp) sweetener (to taste)",
"Cooking spray",
"Salt to taste"
}',
'{
"Place the cauliflower in a blender and blend on high until it''s shredded into cauliflower rice.",
"Add the cauliflower rice, oats, Cheddar and Chive egg whites, guar/xanthan gum, sweetener and protein powder to a blender. Blend on medium to form a uniform mixture.",
"Heat up a nonstick skillet with cooking spray over medium-high heat.",
"Spray the skillet with cooking spray for one second.",
"Drop the batter into the heated skillet and cook until the edges and bottom begin to brown.",
"Flip and cook the other side until it is golden brown."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
125,
1,
13,
3,
15,
6
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Double Chocolate Chip Pancakes',
20,
30,
'{
"MAKES 3 PANCAKES",
"240g (1 cup) egg whites",
"300g cauliflower",
"1⁄2 serving fruit of choice (150g strawberries is my preference)",
"45g (1⁄2 cup) rolled oats",
"33g (1 scoop) chocolate casein protein powder",
"3 packets (2 tbsp) sweetener",
"1.5g (~1⁄2 tsp) guar/xanthan gum",
"2g (1⁄2 tsp) baking powder (optional)",
"45g sugar-free chocolate chips",
"5g (1 tbsp) cocoa powder",
"30ml (2 tbsp) Walden Farms sugar-free chocolate syrup",
"Cooking spray"
}',
'{
"Place the cauliflower in a blender and blend on high until it''s shredded into small pieces (like cauliflower rice.)",
"Add the oats, egg whites, protein powder, sweetener, guar or xanthan gum, baking powder (if used), cocoa powder and Walden Farms chocolate syrup into the blender. Blend on medium until the batter is smooth.",
"Heat up a skillet and spray with cooking spray for 1 second. Then, pour the pancake batter in the pan on top of the fruit.",
"Press the chocolate chips and fruit slices on top of the pancake.",
"Flip when it''s ready then cook for a few more minutes.",
"Remove from the pan, serve and enjoy."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
265,
7,
30,
8,
23,
3
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'French Toast Blueberry Pancakes',
15,
20,
'{
"MAKES 2 PANCAKES",
"480g (2 cups) egg whites",
"4 slices regular  bread (up to 80 calories per slice)",
"4 packets (~3 tbsp) sweetener",
"2 tsp cinnamon",
"5g (11⁄2 tsp) guar/xanthan gum",
"100g blueberries",
"Cooking spray",
"OPTIONAL TOPPINGS",
"60ml (4 tbsp) low-calorie syrup (20 calories)"
}',
'{
"In a blender, add bread slices, egg whites, guar/xantham gum, sweetener, and cinnamon.",
"Blend on high until mixture is uniform in consistency. Remove mix from the blender and add to a fridge-safe airtight container.",
"(OPTIONAL): Let sit for 2-3 hours or more in the refrigerator. The longer you let the mixture rest, the better it binds. (Note: it can be cooked right away but it''s better if it has time to sit).",
"Heat a griddle over low-medium heat. Spray griddle with cooking spray. Add mixture to griddle and let sit for 1-2 minutes until edges appear cooked through.",
"Add blueberries to the pancake in the griddle.",
"Once edges start to brown and pancake appears to be visibly cooked about 2⁄3 of the way, flip the pancake in the griddle and let sit another 1-2 minutes.",
"Remove pancake from the griddle and serve on a plate with low- calorie syrup or leftover blueberries."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
330,
4,
40,
4,
32,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Pumpkin Apple Pancakes',
15,
20,
'{
"MAKES 6 PANCAKES",
"100g (~1 cup) rolled oats",
"480g (2 cups) egg whites",
"225g (1 cup) pumpkin purée",
"250g Granny Smith apples, peeled and shredded",
"4 packets (~3 tbsp) sweetener",
"4g (1 tsp) baking soda",
"1 tsp cinnamon (optional)",
"3g (1 tsp) guar gum",
"Cooking spray",
"TOP WITH:",
"60ml (4 tbsp) low-calorie syrup (20 calories)"
}',
'{
"Put the oats in a blender, blend to make a flour-like consistency (optional).",
"In a bowl, add the remaining dry ingredients.",
"In a separate bowl, add pumpkin purée and egg whites, mix well.",
"Combine dry ingredients and wet ingredients into a blender, blend for 5-10 seconds.",
"Remove the batter from the blender and fold in shredded apples.",
"Heat a skillet to medium-low heat.",
"Spray the skillet with cooking spray for 1 second. Add the pancake mixture to the pan and let the pancakes get firm on one side before flipping.",
"Enjoy!"
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
140,
1,
21,
5,
11,
6
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Quick & Easy Pancakes',
15,
20,
'{
"MAKES 2 PANCAKES",
"240g (1 cup) regular or flavored Liquid Muscle or Muscle Egg egg whites",
"25g (3⁄4 scoop) casein protein",
"2 packets (4 tsp) sweetener",
"~1g (1⁄4 tsp) guar gum",
"Cooking Spray",
"TOP WITH:",
"60ml (4 tbsp) low-calorie syrup (20 calories)"
}',
'{
"In a bowl, mix egg whites, casein protein, sweetener, and baking powder/guar gum with a fork until a uniform consistency is achieved.",
"Heat a griddle over low-medium heat. Spray griddle with cooking spray. Add mixture to griddle and let sit for 1-2 minutes until edges appear cooked through.",
"Remove pancake from the griddle and serve on a plate with toppings of choice."
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
255,
1,
13,
0,
47,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Strawberry Cheesecake Protein Pancakes',
15,
20,
'{
"MAKES 3 PANCAKES",
"480g (2 cups) egg whites",
"400g cauliflower",
"1 serving fruit of choice, sliced (300g strawberries recommended) (100 calories)",
 "45g (3⁄8 cup) rolled oats",
"50g (11⁄2 scoop) strawberry cheesecake (or flavour of choice) protein powder",
"3 packets (2 tbsp) sweetener to taste",
"1.5g (1⁄2 tsp) guar gum/xanthan gum",
"Cooking spray"
}',
'{
"Place the cauliflower in a blender and blend on high until it''s shredded.",
"Place the remaining ingredients in the blender except the serving of fruit, and blend until smooth.",
"Heat a skillet over low-medium heat. Spray with cooking spray for 1 second, then pour mixture onto the pan.",
"Place the fruit on top of the pancakes while they''re cooking.",
"Flip once the bottom is golden brown or until desired doneness. Enjoy!"
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
285,
3,
44,
13,
25,
3
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Vanilla Chocolate Chip Pancakes',
15,
20,
'{
"MAKES 2 PANCAKES",
"240g (1 cup) egg whites",
"300g cauliflower",
"45g (3⁄8 cup) rolled oats",
"33g (1 scoop) vanilla casein protein powder",
"3 packets (2 tbsp) sweetener",
"1.5g (1⁄2 tsp) guar or xanthan gum",
"45g sugar-free chocolate chips",
"Cooking spray"
}',
'{
"Place the cauliflower in a blender and blend on high until it''s shredded into small pieces (like cauliflower rice).",
"Add into the blender oats, protein powder, egg whites, guar/xanthan gum, baking powder (if used) and sweetener. Blend until the mixture is well blended.",
"Heat a nonstick skillet on low-medium heat. Spray the skillet with cooking spray for 1 second. Pour the mixture into the heated skillet.",
"Add the sugar-free chocolate chips on the pancakes while in the pan.",
"Flip the pancake when you feel like it and eat when ready (and don''t forget to put the fork down)!!"
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
350,
10,
39,
9,
32,
2
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Pumpkin Spice Loaf',
20,
60,
'{
"MAKES 5 SERVINGS",
"225g (1 cup) pumpkin purée",
"66g (2 scoops) cinnamon or vanilla protein powder",
"20g (3 tbsp) oat flour",
"25g (1⁄4 cup) almond flour",
"6 packets (1⁄4 cup) sweetener",
"3g (1⁄2 tsp) baking soda",
"4 tsp cinnamon",
"5g (1 tsp) vanilla extract",
"15g sugar-free chocolate chips (optional)"
}',
'{
"Preheat the oven to 350°F/177°C.",
"Blend all ingredients together in a blender (except for the chocolate chips.)",
"Fold the chocolate chips into the batter.",
"Spray a loaf pan with cooking spray for 1 second. Then, pour the batter into the loaf pan.",
"Place in the oven and bake for 15-20 minutes, or until a toothpick comes out clean.",
"Let cool completely. Slice and serve."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
140,
5,
14,
4,
14,
5
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Apple Cinnamon Muffins',
10,
20,
'{
"MAKES 6 MUFFINS",
"250g (1 cup) unsweetened applesauce",
"45ml (3 tbsp) unsweetened almond milk",
"10g (2 tsp) vanilla extract",
"10g (2 tsp) apple cider vinegar",
"65g (~1⁄2 cup) oat flour",
"43g (~11⁄3 scoop) vanilla or cinnamon protein powder",
"12 packets (1⁄2 cup) sweetener",
"1⁄2 tsp sea salt",
"2.5g (1⁄2 tsp) baking powder",
"1g (1⁄4 tsp) baking soda",
"1⁄4 tsp cinnamon (if not using cinnamon protein powder you can add more)",
"80g chopped apples"
}',
'{
"Preheat the oven to 350°F/177°C.",
"In a bowl mix all the wet ingredients together.",
"In a separate bowl mix all the dry ingredients (leave chopped apples out until last).",
"Once both are mixed, combine together and stir thoroughly until smooth.",
"Add in some (but not all) of the chopped apples and then fold into the mixture.",
"Scoop the muffin mixture into the silicone muffin mold until the well is 3⁄4 full. Add the remaining apples to the tops of the muffin molds.",
"Bake in the preheated oven for 18 minutes or until a toothpick comes out clean.",
"Let the muffins cool in the molds for a few minutes before removing and serving."
}',
TRUE,
TRUE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
100,
1,
15,
2,
9,
6
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Banana Chocolate Protein Muffins',
10,
40,
'{
"MAKES 8 MUFFINS",
"220g banana",
"125g (1⁄2 cup) 0% fat Greek yogurt",
"200g (~7/8 cup) egg whites",
"90g (~3⁄4 cup) self-rising flour",
"132g (4 scoops) chocolate protein powder (520 calories, 100g protein)",
"4g (1 tsp) baking soda",
"5g (1 tsp) baking powder",
"5g (1 tsp) vanilla extract"
}',
'{
"Preheat the oven to 350°F (177°C). Place liners in a muffin tin and spray them with cooking spray.",
"In a bowl, mix all the dry ingredients together well. In a separate bowl or a stand mixer, whip together the rest of the ingredients until smooth. Add the dry ingredients to the wet ingredients and mix until incorporated.",
"Fill the muffin liners about 3⁄4 of the way full with the batter. Bake the muffins in the oven for 20 minutes or until a toothpick comes out clean when you prick the muffins.",
"Remove the muffins from the oven and allow to cool for 20 minutes before serving."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
155,
2,
19,
2,
19,
8
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Blueberry Protein Muffins',
10,
40,
'{
"MAKES 10 MUFFINS",
"250g (1 cup) unsweetened apple sauce",
"175g (~3⁄4 cup) 0% fat Greek yogurt",
"60g (1⁄4 cup) egg whites",
"66g (2 scoops) cinnamon or vanilla protein powder",
"240g (2 cups) oat flour",
"270g fresh blueberries",
"5g (1 tsp) vanilla extract",
"6 packets (1⁄4 cup) sweetener",
"6g (11⁄2 tsp) baking powder",
"4g (1⁄2 tsp) baking soda"
}',
'{
"Preheat the oven to 163°C (325°F).",
"Combine all wet ingredients into a bowl and mix until evenly distributed.",
"In another bowl, combine all dry ingredients and mix. Then, combine the wet and dry ingredients in a bowl.",
"Mix until you get a smooth consistency. Fold in blueberries.",
"Spray a muffin tray with cooking spray, and pour the batter into the muffin trays. Be sure to leave approx 1⁄4 - 1⁄2 inch (~1 cm) of room for the muffins to rise in each tray.",
"Bake for 15-20 minutes, or until a toothpick comes out clean (DON''T over bake or else they will be dry.)",
"Let cool on a cooling rack and serve."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
160,
2,
24,
3,
12,
10
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Carrot Apple Muffins',
20,
45,
'{
"MAKES 10 MUFFINS",
"190g (~11⁄2 cups) oat flour",
"200g carrots, shredded",
"100g (3 scoops) vanilla protein powder",
"180g (3⁄4 cup) egg whites",
"185g (3⁄4 cup) unsweetened applesauce",
"100g (1 cup) crushed fresh Granny Smith apples",
"10g (2 tsp) vanilla extract",
"4g (1 tsp) baking soda",
"1 tsp Kosher salt",
"1 tsp cinnamon",
"TO TASTE:",
"10 packets (3 tbsp) sweetener"
}',
'{
"Preheat the oven to 350°F (177°C). Line a muffin tin with cupcake liners and spray with cooking spray.",
"In a large bowl, mix all the dry ingredients together thoroughly. In a separate bowl, mix all the rest of the ingredients together.",
"Add the wet ingredients to the dry ingredient and mix well until everything is well incorporated.",
"Fill the cupcake liners about 3⁄4 full of the batter. ''I put 1⁄4 cup in each cupcake liner!in",
"Bake in the oven for 20 minutes or until a toothpick comes out clean when you prick the cake with one.",
"Remove from the oven and allow to cool down for at least 20 minutes before serving."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
155,
2,
23,
6,
13,
10
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Banana Muffins',
15,
45,
'{
"MAKES 10 MUFFINS",
"100g (3 scoops) chocolate whey protein powder",
"330g banana",
"180g (3⁄4 cup) egg whites",
"125g (~1⁄2 cup) 0% fat Greek yogurt",
"80g (~2⁄3 cup) oat flour",
"25g (5 tbsp) cocoa powder",
"75g sugar-free chocolate chips",
"180ml (3⁄4 cup) Stevia",
"30ml (2 tbsp) hot water",
"8g (2 tsp) baking powder",
"1⁄2 tsp Kosher salt",
"5g (1 tsp) vanilla extract"
}',
'{
"Preheat the oven to 350°F/177°C. Place liners in a muffin tin and spray them with cooking spray.",
"In a bowl, mix all the dry ingredients together well.",
"In a separate bowl or a stand mixer, whip together the rest of the ingredients until smooth. Add the dry ingredients to the wet ingredients and mix until well mixed.",
"Fill the muffin liners about 3⁄4 of the way full with the batter. Bake the muffins in the oven for 20 minutes or until a toothpick comes out clean when you prick the muffins.",
"Remove the muffins from the oven and allow to cool for 20 minutes before serving."
}',
TRUE,
FALSE,
FALSE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
160,
4,
21,
3,
13,
10
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Frosted Peanut Butter Banana Protein Muffins',
10,
40,
'{
"MAKES 4 MUFFINS",
"140g (~1⁄2 cup) 0% fat Greek yogurt",
"110g banana",
"20g (~3 tbsp) powdered peanut butter (PB2)",
"60g (1⁄2 cup) oat flour",
"33g (1 scoop) protein powder",
"5g (1 tsp) baking powder",
"FROSTING",
"125g (1⁄2 cup) 0% fat Greek yogurt",
"30g (5 tbsp) powdered peanut butter (PB2)"
}',
'{
"Pre-heat the oven to 176°C (350°F).",
"Blend all ingredients in a blender until there is a smooth batter.",
"Add the mixture into a muffin pan or a regular baking pan. Be sure to spray the pan with cooking spray before adding the batter.",
"Bake at 176°C (350°F) for 20-25 minutes or until you can stick a toothpick into the muffin and the toothpick comes out clean.",
"While the muffins are baking, prepare the frosting by mixing the Greek yogurt and powdered peanut butter.",
"Remove the muffins from the oven and let sit to cool completely to firm up.",
"Apply the frosting to each muffin if desired and serve."
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
205,
3,
24,
4,
22,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Pumpkin Protein Muffins',
15,
40,
'{
"MAKES 8 MUFFINS",
"165g (5 scoops) vanilla protein powder",
"32g (~1⁄4 cup) coconut flour",
"64g erythritol or ~7 packets sweetener",
"225g (1 cup) pumpkin purée",
"120g (1⁄2 cup) egg whites",
"2 tsp pumpkin pie spice",
"20g (4 tsp) baking powder",
"1⁄2 tsp salt",
"5g (1 tsp) vanilla extract"
}',
'{
"Preheat the oven to 350°F (177°C). Place cupcake liners in a muffin tin and spray them with cooking spray.",
"In a large bowl, mix all the dry ingredients together well. In a separate bowl, mix all the rest of the ingredients together. Add the wet ingredients to the dry ingredient and mix well until everything is incorporated.",
"Fill the cupcake liners about 3⁄4 full of the batter. Bake in the oven for 20 minutes or until a toothpick comes out clean.",
"Remove from the oven and allow to cool down for at least 20 minutes before serving."
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
120,
5,
7,
2,
18,
8
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Strawberry Peach Protein Muffins',
20,
60,
'{
"MAKES 10 MUFFINS",
"285g (11⁄4 cup) 0% fat Greek yogurt",
"180g (3⁄4 cup) egg whites",
"30ml (2 tbsp) unsweetened almond milk",
"45ml (3 tbsp) unsweetened applesauce",
"2 packets (or 4 tsp) sweetener",
"5g (1 tsp) vanilla extract",
"160g (~11⁄3 cups) oat flour",
"33g (1 scoop) vanilla whey protein powder",
"2.5g (1⁄2 tsp) baking powder",
"2g (1⁄2 tsp) baking soda",
"40g fresh strawberries, slices",
"40g fresh peaches, chopped",
"FROSTING:",
"30ml (2 tbsp) Swerve 0-Calorie Icing",
"sugar",
"8ml (1⁄2 tbsp) unsweetened almond milk"
}',
'{
"Preheat the oven to 350°F (177°C). Place liners in a muffin tin and spray them with cooking spray.",
"In a bowl, mix all the dry ingredients together well. In a separate bowl or a stand mixer, whip together the rest of the ingredients until smooth. Add the dry ingredients to the wet ingredients and mix until incorporated. Fold in the strawberries and peaches and mix gently with a spoon until mixed.",
"Fill the muffin liners about 3⁄4 of the way full with the batter. Bake the muffins in the oven for 25 minutes or until a toothpick comes out clean when you prick the muffins.",
"While the muffins are in the oven, place the frosting ingredients in a bowl and mix with a fork until well-blended.",
"Remove the muffins from the oven and allow to cool for 15 minutes before placing the icing on top and serving."
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
101,
1,
14,
0,
9,
10
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Sunshine Morning Muffins',
10,
45,
'{
"MAKES 4 MUFFINS",
"350g (~11⁄2 cup) 0% fat Greek yogurt",
"220g ripe banana (mashed)",
"48g (1⁄2 cup) powdered peanut butter (PB2)",
"150g (11⁄4 cup) oat flour",
"66g (2 scoops) chocolate peanut butter protein powder",
"8g (2 tsp) baking powder",
"FROSTING:",
"125g (~1⁄2 cup) 0% fat Greek yogurt",
"30g (5 tbsp) powdered peanut butter (PB2)"
}',
'{
"Preheat the oven to 350°F (177°C). Place liners in a muffin tin and spray them with cooking spray.",
"In a bowl, mix all the dry ingredients together well. In a separate bowl or a stand mixer, whip together the rest of the ingredients until smooth. Add the dry ingredients to the wet ingredients and mix until well mixed.",
"If you don''t want to get a bicep pump from mixing the ingredients manually, you may use a blender. First, put all of the dry ingredients in the blender, and pulse on high until there is an even, powdery consistency. Then, add the wet ingredients and pulse on medium until the batter is smooth and consistent.",
"Fill the muffin liners about 3⁄4 of the way full with the batter. Bake the muffins in the oven for 20-25 minutes or until a toothpick comes out clean when you prick the muffins.",
"Remove the muffins from the oven and allow to cool for 20 minutes before serving.",
"OPTIONAL: If you wish to add frosting, simply mix the Greek yogurt with powdered peanut butter in a bowl, and then add a dollop to the top of each muffin."
}',
TRUE,
FALSE,
TRUE,
'breakfast'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
360,
6,
46,
7,
37,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Delicious Quesadilla',
15,
20,
'{
"MAKES 1 QUESADILLA",
"60g chicken breast, boneless and skinless OR 50g extra-lean ground turkey OR 40g extra-lean ground beef/steak (measured cooked)",
"2 low-carb high-fiber tortillas (70 calories per tortilla)",
"2 slices fat-free cheese or 38g fat-free shredded cheese (60 calories)",
"1⁄2 serving veggies (peppers / onions / jalapenos / mushrooms)",
"40g (3 tbsp) of your favorite salsa",
"30g (2 tbsp) fat-free sour cream",
"Salt & pepper to taste"
}',
'{
"Prep: grill chicken breast/ground turkey/ground beef/steak/etc. with salt & pepper to taste and set aside & refrigerate until you are ready to make your quesadilla.",
"Pre-heat the oven to 375°F (190°C). You may also pre-heat a toaster oven if you have that available in your kitchen.",
"Add aluminum foil to a baking sheet and spray with cooking spray. Lay one tortilla flat on the piece of aluminum foil. Spread the veggies, cheese, and meat/poultry evenly on top of the tortilla. Add the 2nd tortilla on top, like a sandwich.",
"For the light version, you will want to fold the tortilla, so make sure the ingredients only take up half of the tortilla.",
"Place the quesadilla in the oven or toaster oven for 5-10 minutes, or until it has reached desired warmth and doneness.",
"Remove the quesadilla from the oven/toaster oven and place on a plate. Slice like a pizza so you can easily eat it with your hands. Serve with fat-free sour cream and salsa for dipping sauce."
}',
FALSE,
FALSE,
FALSE,
'appetizer'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
365,
9,
60,
35,
34,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Grilled Spicy Peanut Chicken Satay Skewers',
15,
30,
'{
"MAKES 6 SERVINGS",
"670g (24 oz) raw, boneless and skinless chicken breast, cut in 5cm/2in chunks",
"375g carrots, shredded",
"100g green onion, chopped",
"20g fresh cilantro, chopped (optional)",
"90g (1⁄3 cup) chili paste",
"84g (~7/8 cup) peanut butter powder",
"240ml (1 cup) light soy sauce"
}',
'{
"You will need skewers for this recipe. If you are using wooden skewers, make sure to soak them in water for 10 minutes before placing the chicken on them.",
"Place two or three chicken chunks on each of the skewers until the chicken is used up. Heat the grill to medium high and cook the chicken on the skewers till fully cooked or the internal temperature of the chicken is 165°F/74°C. Remove from the grill and allow to rest for a few minutes.",
"In a small bowl, mix the soy sauce, peanut butter powder and chili paste together well. Take the cooked chicken skewers and coat them in the sauce mixture by either brushing them with it or rolling them in the sauce to coat them completely.",
"Transfer the sauced chicken skewers to a plate and sprinkle with the shredded carrots, cilantro and green onions. One entire batch makes 6 small portions. Serve and enjoy!"
}',
FALSE,
FALSE,
FALSE,
'appetizer'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
235,
3,
17,
5,
35,
6
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Protein ''Chips and Guacamolein',
5,
5,
'{
"MAKES 1 SERVING",
"1 Flatout Protein UP Flatbread or protein flatbread of choice (110 calories)",
"Guacamole - 50g avocado, 25g tomato, 25g onions, 25g jalapenos",
"1 tbsp fresh lime juice",
"Salt and pepper"
}',
'{
"Slice an avocado into cubes. Dice tomatos, onions, and jalapenos. Place all in one bowl and mash with a spoon or a pestel. Add lime, salt and pepper to taste.",
"Place Flatout ProteinUP wrap on a baking sheet. Slice wrap into tortilla chip-sized squares. Put in toaster oven for 3 minutes until the pieces are crispy like tortilla chips.",
"Serve together as an appetizer or as a delicious healthy snack."
}',
TRUE,
FALSE,
FALSE,
'appetizer'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
210,
11,
28,
8,
12,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Smoked Salmon Pinwheels',
5,
10,
'{
"MAKES 1 SERVING",
"60g (~2 oz) cold smoked salmon",
"1 low-carb tortilla wrap (Mission Carb Balance Tortilla, 70 calories)",
"50g frozen spinach, thawed and drained",
"30g red onion, shaved",
"10g capers",
"15g low-fat cream cheese (35 calories)",
"1⁄2 tsp black pepper",
"Optional:",
"2 tsp fresh dill, chopped"
}',
'{
"Lay the tortilla wrap out flat and spread the cream cheese around to cover it. Next, cover the whole tortilla with the strips of smoked salmon. Sprinkle the black pepper, capers and dill on the smoked salmon evenly.",
"Spread the shredded spinach and the onions out on top of everything evenly so it is covered with the ingredients. Start at the bottom of the tortilla and roll it up tightly all the way.",
"Use a knife to cut the burrito rollup in sections about 2 inches (5 centimeters) thick. Each section should look like a pinwheel from the side if you rolled it correctly.",
"Transfer the pinwheels to a plate, serve and enjoy!"
}',
FALSE,
FALSE,
FALSE,
'appetizer'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
200,
8,
18,
10,
18,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Cheesy Grilled Egg White French Toast Sandwich',
5,
10,
'{
"MAKES 1 SANDWICH",
"480g (2 cups) egg whites",
"2 slices regular bread (160 calories)",
"2 slices fat-free cheese OR 38g fat-free shredded cheese (60 calories)",
"Salt & pepper to taste",
"Cooking spray",
"Optional:",
"45g (3 tbsp) sugar-free ketchup (add",
"30 calories) OR condiment of choice"
}',
'{
"Heat a non-stick pan over medium/low heat. Spray with cooking spray for one second.",
"Pour egg mixture on pan.",
"Place bread slices on the pan for 15 seconds then flip.",
"Cook for a few minutes until the egg mixture is cooked. You can cover the pan to cook evenly or flip egg whites while cooking until desired readiness.",
"Fold the egg mixture onto the bread slices and place a slice of cheese on top of each slice (add salt & pepper if desired)",
"Place bread slices on top of each other, allowing the cheese to melt inside the sandwich.",
"Turn off the heat, and place the sandwich onto a plate. Eat immediately with a fork with no sugar-added ketchup if desired. THIS IS ONE SITUATION WHERE YOU NEED TO PICK THE FORK UP!!"
}',
TRUE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
480,
3,
40,
2,
69,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Triple-Stack Grilled Egg & Cheese French Toast',
5,
10,
'{
"MAKES 1 SANDWICH",
"375g (11⁄2 cups) egg whites",
"2 whole eggs",
"3 slices regular  bread (240 calories)",
"3 slices (or 57g shredded) fat-free cheese (60 calories)",
"Salt & pepper to taste",
"Cooking spray",
"Optional:",
"45g (3 tbsp) sugar-free ketchup (add",
"30 calories) OR condiment of choice"
}',
'{
"Whisk the eggs and egg whites in a bowl until the mixture is fluffy.",
"Heat a non-stick pan over medium/low heat. Spray with cooking spray for one second.",
"Pour egg mixture on pan.",
"Place bread slices on the pan for 15 seconds then flip.",
"Cook for a few minutes until the egg mixture is cooked. Flip again and cook until the egg is cooked. Then, fold any remaining egg mixture onto the bread slices, and place cheese on top of each slice of bread.",
"Place the triple-stack sandwich onto a plate and eat with a fork and knife, and any condiments you desire."
}',
TRUE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
670,
11,
57,
2,
75,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Grilled Cheese Sandwich on Protein Bread',
5,
10,
'{
"MAKES 1 SANDWICH",
"2 slices ICON Meals protein bread or high-protein bread of choice (140 calories per slice)",
"2 slices OR 38g shredded fat-free cheese (60 calories)",
"9g Becel 50% less fat butter"
}',
'{
"Heat a griddle over low heat, and add low-calorie butter to pan.",
"Add 2 slices of bread to the pan and add cheese on top.",
"Eat as a closed sandwich or as two open face sides, whichever you prefer."
}',
TRUE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
365,
14,
34,
2,
38,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Ham & Cheese Sandwich on Protein Bread',
5,
10,
'{
"MAKES 1 SANDWICH",
"2 slices ICON Meals protein bread or high-protein bread of choice (140 calories per slice)",
"2 slices OR 38g shredded fat-free cheese (60 calories)",
"9g Becel 50% less fat butter",
"2 thin slices of ham (40 calories)"
}',
'{
"Heat a griddle over low heat, and add low-calorie butter to pan.",
"Add 2 slices of bread to the pan and add ham and cheese on top.",
"Eat as a closed sandwich or as two open face sides, whichever you prefer."
}',
FALSE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
405,
14,
34,
4,
48,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Sloppy Joe Sandwich',
10,
25,
'{
"MAKES 4 SERVINGS",
"450g (16 oz) extra lean ground turkey or extra lean meat of choice (measured raw)",
"8 slices regular  bread/bun",
"1 packet Sloppy Joe Seasoning",
"1 jar/can 650-680ml of tomato sauce",
"6g (2 tsp) guar/xanthan gum",
"2 servings (200 calories)",
"Veggies of Choice OR what I use:",
"250g red/yellow/orange bell pepper",
"225g mushrooms",
"250g onion",
"2 tsp garlic (4 garlic cloves)"
}',
'{
"Heat a pan to medium heat. Cook the turkey meat until it fully cooks through. Remove from the pan and drain in a colander/strainer.",
"Add in the onions, garlic, mushrooms and pepper. Cook and stir for 5 minutes or until thoroughly mixed with the meat.",
"Add in the Sloppy Joe Seasoning and the tomato sauce. Mix with a spoon and reduce heat to low.",
"Place one serving (two slices of bread...toasted if you like it crispy!) on a plate and spread 3⁄4 cup (180ml) of the Sloppy Joe mixture on top of bread.",
"Optional: Add a fat-free cheese slice on top of the Sloppy Joe sandwich (adds 30 calories per serving)."
}',
FALSE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
450,
9,
57,
10,
31,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Veggie Sloppy Joe Sandwich',
15,
25,
'{
"MAKES 4 SERVINGS",
"454g (16 oz) ground veggie meat (Gardein or Yves) (495 calories)",
"8 slices regular  bread",
"1 packet of Sloppy Joe seasoning",
"150g (5 oz) can of tomato paste",
"125g (1⁄2 cup) no sugar-added ketchup",
"250g (1 cup) of tomato sauce",
"2 servings (200 calories)",
"Veggies of Choice OR what I use:",
"250g red/yellow/orange bell pepper",
"225g mushrooms",
"250g onion"
}',
'{
"Heat a pan to medium heat. Lightly spray with cooking spray. Warm the veggie meat in the pan until it is thawed.",
"Add in the onions, garlic, mushrooms and pepper",
"Cook and stir for 5 minutes or until thoroughly mixed with the meat",
"Add tomato sauce, ketchup and tomato paste.",
"Add Sloppy Joe Seasoning mix and reduce heat to low.",
"Let simmer for 10 minutes",
"Place two slices of bread on a plate and spread 3⁄4 cup (180ml) of the Sloppy Joe mixture on top of the bread."
}',
TRUE,
TRUE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
420,
5,
58,
10,
33,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Vegan Meatball Sandwich on Protein Bread',
10,
10,
'{
"MAKES 1 SANDWICH",
"2 slices ICON Meals protein bread or high-protein bread of choice (140 calories per slice)",
"4 veggie meatballs (up to 120 calories)",
"Vegetables of choice (15 calories)",
"Recommended to top with lettuce, tomato, & onion",
"Condiments of choice (examples: mustard, horseradish, sugar-free ketchup)"
}',
'{
"Heat up the meatballs in the microwave according to the directions on the package.",
"Toast the bread slices in a toaster oven or toaster.",
"Build the sandwich with the meatballs, lettuce, tomato & onion (or veggies of choice). Top with low-calorie condiments such as mustard, horseradish, or sugar-free ketchup according to your taste preferences."
}',
TRUE,
TRUE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
430,
15,
43,
8,
45,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Veggie Pigs in a Blanket (Hot Dog)',
10,
10,
'{
"MAKES 1 HOT DOG",
"11⁄2 weiners of veggie tofu dogs (70 calories)",
"1 slice regular  bread (80 calories)",
"1 tbsp yellow mustard",
"1 tbsp ketchup"
}',
'{
"Toast the bread slices in a toaster oven or toaster.",
"Lay the bread slices flat and spread mayonnaise. Optionally add additional low-calorie condiments such as mustard or horseradish according to your taste preferences.",
"Build the sandwich with the remaining ingredients. Slice in half and serve."
}',
TRUE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
170,
3,
23,
1,
14,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chicken/Tuna, Lettuce & Tomato on Protein Bread',
3,
5,
'{
"MAKES 1 SANDWICH",
"2 slices ICON Meals protein bread or high-protein bread of choice (140 calories per slice)",
"Sliced tomato (up to 20 calories)",
"Lettuce (up to 10 calories)",
"4 thin slices of chicken OR 1⁄2 can of water-packed tuna (65 calories)",
"14g (1 tbsp) light mayonnaise (up to 30 calories)"
}',
'{
"Place the bread in the toaster until cooked to a light golden brown.",
"Lay the toast flat on a plate and spread the mayonnaise on the bread.",
"Place the chicken or tuna on top of the bread, and then lettuce and tomato.",
"Top with the 2nd layer of bread. Serve and enjoy."
}',
FALSE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
445,
12,
38,
5,
43,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Powdered Peanut Butter and Jam Sandwich on Protein Bread',
5,
5,
'{
"MAKES 1 SANDWICH",
"2 slices ICON Meals protein bread or high-protein bread of choice (140 calories per slice)",
"20g (~2 tbsp) low-calorie jam (up to 40 calories)",
"18g (3 tbsp) powdered peanut butter (PB2)",
"15ml (1 tbsp) water"
}',
'{
"Toast bread slices in the toaster until they have a light brown crisp.",
"Mix powdered peanut butter in a bowl with 1 tbsp water (or more or less depending on desired thickness), and stir until an even consistency is achieved.",
"Spread powdered peanut butter mixture on the bread slices. Then add low-calorie jam. Eat as a closed sandwich or as two open face sides, whichever you prefer. Enjoy!"
}',
TRUE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
390,
12,
48,
8,
37,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Powdered Peanut Butter & Banana on Protein Bread',
3,
3,
'{
"MAKES 1 SANDWICH",
"2 slices ICON Meals protein bread or high-protein bread of choice (140 calories per slice)",
"110g banana",
"12g (2 tbsp) powdered peanut butter",
"1 tbsp water"
}',
'{
"Toast bread slices in the toaster until it has a light brown crisp.",
"Mix powdered peanut butter in a bowl with 1 tbsp water (or more or less depending on desired thickness), and stir until an even consistency is achieved.",
"Spread the peanutty mixture on the bread slices. Then add sliced banana. Eat as a closed sandwich or as two open face sides, whichever you prefer. Enjoy!"
}',
TRUE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
425,
12,
61,
9,
37,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Veggie Bologna Sandwich',
10,
10,
'{
"MAKES 1 SANDWICH",
"2 slices regular  bread (160 calories)",
"4 slices veggie bologna (80 calories)",
"1 fat-free cheese slice or 19g shredded fat-free cheese (30 calories)",
"Vegetables of choice (15 calories)",
"Recommended to top with lettuce, tomato, & onion",
"Condiments of choice (30 calories) Mustard, horseradish, sugar-free ketchup, light mayonnaise, etc."
}',
'{
"Toast the bread slices in a toaster oven or toaster.",
"Lay the bread slices flat and spread mayonnaise. Optionally add additional low-calorie condiments such as mustard or horseradish according to your taste preferences.",
"Build the sandwich with the remaining ingredients. Slice in half and serve."
}',
TRUE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
325,
8,
39,
5,
23,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Grilled Chicken Wrap with Mango Relish',
10,
10,
'{
"MAKES 2 WRAPS",
"110g (4 oz) chicken breast, boneless and skinless (raw)",
"2 low-carb tortilla wraps (La Tortilla brand - 110 calories each, 220 calories total)",
"55g green cabbage, shredded",
"55g red cabbage, shredded",
"60g carrots, julienned/cut into thin strips",
"60g mango, diced",
"30g pineapple, diced",
"15g red onion, diced",
"1 tbsp cilantro, chopped",
"1 tbsp rice wine vinegar",
"Salt and pepper"
}',
'{
"In a bowl, mix together the mango, pineapple, cilantro and onion. Place in the fridge or to the side until you are ready for it.",
"In a separate bowl, mix together the red and green cabbage, carrots, rice wine vinegar, 1⁄2 tsp salt and 1⁄2 tsp pepper. Set to the side.",
"Season the chicken with salt and pepper and place on the grill. Cook over medium high heat for 3-5 minutes on each side or until the chicken is fully cooked. Remove the chicken from the grill and cut into 1-inch strips.",
"Begin to build the wraps with the grilled chicken, slaw and mango relish. Serve and enjoy!"
}',
FALSE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
220,
4,
30,
16,
22,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'White Fish with Coleslaw Tacos',
10,
30,
'{
"MAKES 4 TACOS",
"Ingredients for the slaw salad",
"200g (2 cups) purple cabbage",
"85g (1⁄3 cup) 0% fat Greek yogurt",
"4 Mission or Mama Lupe''s Tortillas (70 calories each)",
"15g green onion",
"15g red onion",
"100g tomato",
"Juice of 1 lime",
"1 clove of garlic",
"Salt and pepper to taste",
"Ingredients for the Fish",
"200g (7 oz) Haddock RAW / 150g",
"Haddock COOKED",
"Salt, pepper, cumin and coriander to taste"
}',
'{
"Directions for slaw salad",
"Shred the cabbage into long thin strips and put into a large mixing bowl.",
"Cut the green onion, red onion and minced garlic, add it into the cabbage bowl and toss to mix.",
"Add in the Greek yogurt and give it a stir.",
"Pour lime juice, salt and pepper into the coleslaw mix, stir well and set aside.",
"Directions for Fish",
"In a bowl, mix all the desired seasonings (salt, pepper, cumin and coriander) to taste. Place the haddock in the bowl and toss until both sides are fully coated with seasoning.",
"Place fish on a skillet on medium heat, only flip when the sides are turning white, flip the fish and cook for a few more minutes.",
"Build your taco: in the center of the tortilla from one end to the other, place the slaw salad cover with pieces of the haddock and put tomato over the fish."
}',
FALSE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
420,
9,
60,
13,
32,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Deli Meat Rice Cake',
3,
5,
'{
"MAKES 4 SANDWICHES (1 SERVING)",
"4 original or lightly salted rice cakes",
"8 slices (140g/5 oz) of oven-roasted turkey or chicken deli meat of choice",
"30g (2 tbsp) low-fat or fat-free mayonnaise (up to 70 calories)",
"10g (2 tsp) Sriracha",
"30g (2 tbsp) dijon mustard",
"Salt and Pepper to taste",
"Veggies of your choice (up to 10 calories total)",
"Tomato, red onion, spinach, lettuce"
}',
'{
"Place one slice of the roasted turkey or chicken on top of the rice cakes.",
"In a bowl, mix mayonnaise, Dijon mustard and Sriracha. Spread over the deli meat.",
"Place veggies on tops of shredded chicken",
"Top with second piece of deli meat",
"Top with two or more layers of lettuce. Serve and enjoy!"
}',
FALSE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
410,
7,
41,
1,
35,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Spicy Shredded Chicken on Rice Cakes',
20,
30,
'{
"MAKES 4 SANDWICHES (1 SERVING)",
"4 original or lightly salted rice cakes",
"100g chicken breast (measured raw) (130 calories)",
"30g (2 tbsp) low-fat or fat-free mayonnaise (up to 70 calories)",
"15g (1 tbsp) Sriracha",
"15g (1 tbsp) dijon mustard",
"Salt and Pepper to taste",
"Veggies of your choice (up to 10 calories total)",
"Tomato, red onion, spinach, lettuce"
}',
'{
"Boil chicken breast in a pot of water until fully cooked for about 10-15 minutes.",
"Remove chicken from the pot and transfer to a cutting board. Pat dry. Shred the chicken breast. You can do this with a fork, with a large grater, or with your hands.",
"In a bowl, mix mayonnaise, Dijon mustard and Sriracha.",
"Place the chicken in the bowl with the mayo, mustard, and sriracha, and toss well until all of the chicken is coated.",
"Arrange rice cakes on a plate. Spread chicken over the four rice cakes.",
"Place veggies on top of the shredded chicken.",
"Top with one large piece of lettuce.",
"Serve and enjoy."
}',
FALSE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
375,
8,
35,
1,
25,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Veggie Meat Rice Cake Sandwich',
5,
5,
'{
"MAKES 1 SERVING",
"1 plain or lightly salted rice cake",
"2 slices of veggie meat (40 calories)",
"1 tbsp of Dijon mustard",
"Veggies of your choice (up to 10 calories total):",
"Lettuce, spinach, cucumber, tomato, red onion (cut thin)"
}',
'{
"Lay 1 slice of veggie meat on top of the rice cake.",
"Add the Dijon mustard on top of the veggie meat.",
"Top with all the veggies of your choice.",
"Lay the second slice of veggie meat and top with lettuce and eat."
}',
TRUE,
TRUE,
TRUE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
90,
1,
12,
1,
6,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Smoked Salmon Rice Cake Sandwich',
0,
5,
'{
"MAKES 1 SERVING",
"1 rice cake",
"28g (~1 oz) smoked salmon (35-60 calories, depending on type of salmon used)",
"15g (1 tbsp) fat-free cream cheese (15 calories)",
"Pepper to taste",
"Veggie Options (5-10 calories total):",
"Spinach, tomato, capers, red onion, Romaine lettuce"
}',
'{
"Set the rice cake on a plate. Spread the cream cheese on the rice cake.",
"Place the smoked salmon on top of the cream cheese.",
"Add veggies of your choice. Top with lettuce and enjoy."
}',
FALSE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
120,
4,
10,
1,
8,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Open-Face Tuna Rice Cakes',
0,
5,
'{
"MAKES 2 SERVINGS",
"1 can of tuna",
"15g (1 tbsp) fat-free or low-fat mayonnaise (up to 35 calories)",
"1 tbsp of dijon mustard",
"1 tbsp pickles of your choice, cut in small pieces",
"20g red onion, diced",
"4 plain or lightly salted rice cakes",
"Veggies of your choice (up to 15 calories total)",
"Tomato, red onion, spinach, lettuce",
"Pepper to taste"
}',
'{
"Make the tuna salad. Drain the tuna and place in a bowl with the red onion, light mayonnaise, dijon mustard, diced pickles, and pepper. Mix with a fork until there is a creamy consistency.",
"Lay out the rice cakes and spread the tuna salad on top of the rice cakes.",
"Add the remaining veggies on top of the tuna salad. Top with lettuce and eat as an open-faced sandwich."
}',
FALSE,
FALSE,
FALSE,
'lunch'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
330,
5,
35,
1,
35,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Cauliflower Pizza',
10,
45,
'{
"MAKES 4 CRUSTS",
"100g (~7/8 cup) self-raising flour",
"700g (3 cups) of cooked cauliflower rice",
"180g (3⁄4 cup) egg whites",
"250g (1 cup) 0% fat Greek yogurt",
"9g (1 tbsp) guar/xanthan gum",
"1 tsp garlic powder",
"1⁄4 tsp Kosher salt",
"1⁄2 tsp oregano",
"1⁄2 tsp basil"
}',
'{
"OPTIONAL: Prep cauliflower rice (either see the recipe in this book on page 124 or purchase pre-cooked cauliflower rice.)",
"Pre-heat the oven to 400°F/204°C.",
"In a bowl mix flour, guar/xanthan gum, garlic powder, salt, oregano, and basil.",
"Add in the Greek yogurt and fold together to form a ball.",
"In another bowl combine cooked cauliflower rice and egg whites. Mix well.",
"Add the cauliflower mixture to the flour mixture and mix well. You can use your hands or a hand blender.",
"Let stand at room temperature for 20 minutes.",
"Divide the mixture into six 150g portions.",
"Cover a baking sheet with parchment paper and spread the mixture into a ‘circle''.",
"Bake at 400°F/204°C for 30-35 minutes or until lightly browned.",
"Remove from the oven and let cool for a few minutes."
}',
TRUE,
FALSE,
TRUE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
200,
1,
32,
5,
14,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Egg White Wrap and Cauliflower Pizza',
10,
45,
'{
"MAKES 4 CRUSTS",
"120g self-rising flour",
"4 Crepini wraps or equivalent egg white wrap of choice (30 calories each)",
"700g (3 cups) of cooked cauliflower rice",
"120g (1⁄2 cup) egg whites",
"225g (~1 cup) 0% fat Greek yogurt",
"9g (1 tbsp) guar/xanthan gum",
"1 tsp garlic powder",
"1⁄4 tsp Kosher salt",
"1⁄2 tsp oregano",
"1⁄2 tsp basil"
}',
'{
"OPTIONAL: Prep cauliflower rice (either see the recipe in this book on page 124 or purchase pre-cooked cauliflower rice.)",
"Pre-heat oven to 400°F/204°C.",
"In a bowl mix dry ingredients (flour, guar gum/xanthan, garlic powder, salt, oregano, and basil).",
"Add in the Greek yogurt and fold together to form a ball.",
"In another bowl combine cooked cauliflower rice and egg whites. Mix well.",
"Add the cauliflower mixture to the flour mixture and mix well. You can use your hands or a hand blender.",
"Let stand at room temperature for 20 minutes.",
"Lay the Crepini wraps on parchment paper and spread the mixture over the wrap.",
"Divide the mixture into 4 equal amounts",
"Bake at 400°F/204°C for 30-35 minutes or until lightly browned.",
"Take out of the oven and let cool for a few minutes."
}',
TRUE,
FALSE,
TRUE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
240,
2,
38,
7,
16,
4
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'''Flatoutin Pizza with Bison',
10,
20,
'{
"MAKES 2 MINI PIZZAS",
"2 ''Flatoutin Rustic White Artisan Thin Pizza Crust or 2 thin pizza crusts of choice (260 calories)",
"2 slices OR 38g fat-free cheese (60 calories)",
"100g ground bison (measured cooked)",
"125g (1⁄2 cup) low-fat pizza sauce (up to 50 calories)",
"Toppings of choice (up to 50 calories):",
"Peppers, onions, mushrooms, spinach",
"Cooking spray",
"Spices (to taste)"
}',
'{
"Heat a frying pan over medium heat. Add cooking spray and sauté onions, mushrooms, and peppers until fully cooked through. Add ground bison and sauté until fully cooked.",
"Toast the pizza crusts on a baking sheet in the oven or toaster oven at 350°F (177°C) for 3 minutes. Remove from the oven and let sit for a few minutes.",
"Add all ingredients to the flatbread except for the cheese. Place in oven for another 3 minutes.",
"Place the cheese slices on the pizzas and place in the oven for 3 minutes. Remove from the oven and enjoy the melted deliciousness."
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
310,
6,
38,
4,
27,
2
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'''Golden Homein Protein Pizza with Beef',
10,
20,
'{
"MAKES 1 MINI PIZZA",
"1 ''Golden Homein Ultra Thin",
"Protein pizza crust (130 calories)",
"1 slice OR 19g shredded fat-free cheese (30 calories)",
"35g extra lean ground beef (measured cooked)",
"70g (1⁄4 cup) pizza sauce (25 calories)",
"Toppings of choice:",
"peppers / onions / mushrooms / spinach"
}',
'{
"Heat a frying pan over medium heat. Add cooking spray and sauté onions, mushrooms, and peppers until fully cooked through. Add ground bison and sauté until fully cooked.",
"Toast ''Golden Homein Ultra Thin Pizza Crusts at 350°F (177°C) on a baking sheet for 3 minutes. Remove from oven and let sit for a few minutes.",
"Add all ingredients to the flatbread except for the cheese. Place in oven for another 3 minutes.",
"Place the cheese slices on the pizzas and place in the oven for 3 minutes. Remove from the oven and enjoy the melted deliciousness."
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
275,
4,
39,
5,
20,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Anabolic Meat Lasagna - Light',
30,
90,
'{
"MAKES 6 SERVINGS",
"2 cans (28 oz) Palmini low carb lasagna",
"8 slices fat-free cheese (or 152g shredded fat-free cheese) (240 calories)",
"500g frozen spinach, thawed and drained",
"250g zucchini, sliced lengthwise",
"455g low-fat ricotta cheese",
"455g 93% lean ground turkey/chicken (measured raw)",
"1000g (4 cups) of flavoured pasta",
"sauce of choice (up to 50 calories per 125g)",
"125g onion, diced",
"2 tsp minced garlic or 2 garlic cloves, minced",
"80ml (1⁄3 cup) water"
}',
'{
"Pre-heat the oven to 400°F (204°C).",
"Sauté garlic and onions on a pan over medium-high heat until golden brown.",
"Remove the onions and garlic and set aside in a large bowl.",
"In the same pan, cook the lean ground turkey until fully cooked. When fully cooked, remove from the pan, drain/rinse out any excess liquid, and add to the bowl of onions & garlic.",
"Add pasta sauce to the turkey mixture and mix well.",
"In a separate bowl, mix Ricotta cheese and spinach.",
"Spray a casserole dish with cooking spray and build the lasagna. Spread 1⁄4 cup of the turkey sauce on the bottom of the casserole dish. Place lasagna noodles over the sauce. Lay zucchini on top of the noodles. Spread 1⁄2 of the ricotta cheese/spinach mix on top of the zucchini. Spread 1⁄3 of the turkey pasta mix over the ricotta. Repeat with another layer of lasagna noodles and zucchini. Spread the remaining pasta sauce on top, and the place fat-free cheese on top of that.",
"Cover with foil (spray with cooking spray) and place in the oven. After 30 minutes, remove the foil and bake for another 30 minutes.",
"Let cool (20 minutes) before cutting and serving."
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
340,
10,
25,
5,
30,
6
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Anabolic Meat Lasagna',
30,
90,
'{
"MAKES 6 SERVINGS",
"9 regular  lasagna sheets",
"8 slices fat-free cheese (or 152g shredded fat-free cheese) (240 calories)",
"500g frozen spinach, thawed and drained",
"250g zucchini, sliced lengthwise",
"455g low-fat ricotta cheese",
"455g 93% lean ground turkey/chicken (measured raw)",
"1000g (4 cups) of flavoured pasta",
"sauce of choice (up to 50 calories per 125g)",
"125g onion, diced",
"2 tsp minced garlic or 2 garlic cloves, minced",
"80ml (1⁄3 cup) water"
}',
'{
"Pre-heat the oven to 400°F (204°C).",
"Cook the lasagna according to package instructions, and set aside.",
"Sauté garlic and onions on a pan over medium-high heat until golden brown.",
"Remove the onions and garlic and set aside in a large bowl.",
"In the same pan, cook the lean ground turkey until fully cooked. When fully cooked, remove from the pan, drain/rinse out any excess liquid, and add to the bowl of onions & garlic.",
"Add pasta sauce to the turkey mixture and mix well.",
"In a separate bowl, mix Ricotta cheese and spinach.",
"Spray a casserole dish with cooking spray and build the lasagna. Spread 1⁄4 cup of the turkey sauce on the bottom of the casserole dish. Place lasagna noodles over the sauce. Lay zucchini on top of the noodles. Spread 1⁄2 of the ricotta cheese/spinach mix on top of the zucchini. Spread 1⁄3 of the turkey pasta mix over the ricotta. Repeat with another layer of lasagna noodles and zucchini. Spread the remaining pasta sauce on top, and the place fat-free cheese on top of that.",
"Cover with foil (spray with cooking spray) and place in the oven. After 30 minutes, remove the foil and bake for another 30 minutes.",
"Let cool (20 minutes) before cutting and serving."
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
535,
12,
68,
6,
35,
6
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Anabolic Veggie Lasagna',
30,
90,
'{
"MAKES 6 SERVINGS",
"9 regular lasagna sheets",
"8 slices fat-free cheese (or 152g shredded fat-free cheese) (240 calories)",
"500g frozen spinach, thawed and drained",
"250g zucchini, sliced lengthwise",
"500g 0% fat cottage cheese",
"330g Yves Veggie Ground Round (or equivalent veggie ground beef of choice up to 330 calories)",
"1000g (4 cups) of flavoured pasta",
"sauce of choice (up to 50 calories per 125g [1⁄2 cup])",
"125g onion, diced",
"2 garlic cloves, minced",
"80ml (1⁄3 cup) water"
}',
'{
"Pre-heat the oven to 400°F (204°C).",
"Cook the lasagna according to package instructions, and set aside.",
"Sauté garlic and onions on a pan over medium-high heat until golden brown.",
"Remove the onions and garlic and place in a large bowl.",
"In the same pan, cook the lean ground ''meatin until fully cooked. When fully cooked, remove from the pan, drain/rinse out any excess liquid, and add the the bowl with onion & garlic.",
"Add pasta sauce to the ground round mixture and mix well.",
"In a separate bowl mix the cottage cheese and spinach.",
"Spray a casserole dish with cooking spray and build the lasagna. Spread 1⁄4 cup of the ''meatin sauce on the bottom of the casserole dish. Place lasagna noodles over the sauce. Lay zucchini on top of the noodles. Spread 1⁄2 of the ricotta cheese/spinach mix on top of the zucchini. Spread 1⁄3 of the turkey pasta mix over the ricotta. Repeat with another layer of lasagna noodles and zucchini. Spread the remaining pasta sauce on top, and the place fat-free cheese on top of that.",
"Cover with foil (spray with cooking spray) and place in the oven. After 30 minutes, remove the foil and bake for another 30 minutes.",
"Let cool (20 minutes) before cutting and serving."
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
470,
6,
70,
8,
36,
6
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Baked Lemon Garlic Salmon with Asparagus',
10,
30,
'{
"MAKES 6 SERVINGS",
"1000g (35 oz) salmon filet",
"1000g asparagus spears",
"500g yellow onion, diced",
"1 - 2 tsp minced garlic (or 2 garlic cloves, minced)",
"Lemons + slices of the lemon",
"Spices: Kosher salt, black pepper, & garlic powder (to taste)",
"1 tsp fresh dill, chopped"
}',
'{
"Preheat the oven to 450°F/232°C.",
"In a large bowl, add the asparagus, minced garlic, onions, lemon zest, 1 tsp kosher salt and 1 tsp black pepper.",
"Spray with little cooking spray for 2 seconds and toss the veggies well.",
"Season the salmon with the other salt, pepper and garlic powder to taste. Place the salmon on a baking sheet.",
"Sprinkle the dill on top of the salmon and cover with the lemon slices to cover.",
"Arrange the asparagus spears on the same baking sheet tray around the salmon making sure they are spread out and not overlapping each other.",
"Bake the salmon and asparagus in the oven for 12 minutes or until the asparagus is soft and tender and the salmon is cooked through and flaky.",
"Transfer the salmon and asparagus to a plate and serve."
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
425,
20,
16,
4,
41,
6
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chicken Cacciatore',
15,
30,
'{
"MAKES 4 SERVINGS",
"300g (11oz) chicken breast, boneless and skinless, cut in 1-inch cubes",
"700g tomato, diced",
"200g yellow onion",
"200g celery, diced",
"200g white mushrooms, sliced",
"4 garlic cloves, minced",
"500ml chicken broth",
"156g (1 small can 2⁄3 cup) tomato paste",
"Salt and pepper to taste"
}',
'{
"Spray a nonstick skillet with cooking spray and add the chicken. Sear the chicken on all sides.",
"Add the chicken broth to the skillet with all the remaining ingredients and stir well.",
"Bring the mixture to a rolling boil, then cover with a lid and reduce to a low simmer. Continue to cook on medium low heat for 20 minutes. After 20 minutes, remove the lid and raise the temperature to medium high. Cook for 5 minutes to reduce the liquid in the skillet and form a thick sauce. You want the sauce to be slightly thick but not too much. The dish is supposed to be almost like a stew.",
"Remove from the heat and transfer the chicken cacciatore to a bowl. Garnish with fresh chopped parsley, serve and enjoy!"
}',
FALSE,
FALSE,
TRUE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
255,
4,
27,
7,
29,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chicken Nugget Bites',
20,
40,
'{
"MAKES 1 SERVING",
"454g (16 oz) raw chicken breast",
"60g (1⁄4 cup) egg whites",
"1 tbsp Italian salad dressing",
"1 tsp paprika",
"1⁄4 tsp cumin",
"1⁄2 tsp garlic powder",
"1 tsp salt",
"1 tsp parsley flakes OR Mrs. Dash (Any flavor)"
}',
'{
"Cut the chicken breast into small pieces and put in a bowl or in a zip-top bag.",
"Pour Italian Salad Dressing over the chicken breast, toss well, zeal and refrigerate for at least 5 hours (best to leave overnight).",
"Pour the egg whites in a separate bowl.",
"Remove the piece of chicken from the bag and dip in the egg whites, repeat this for all the chicken pieces.",
"Rub the chicken pieces with Mrs Dash Spice or the mixed spices.",
"Place in an air fryer for 10 minutes.",
"Remove from the air fryer, serve and enjoy."
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
500,
12,
5,
1,
92,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Citrus Tilapia, Shrimp & Vegetables',
15,
35,
'{
"MAKES 5 SERVINGS",
"850g (30oz) tilapia filet (measured raw)",
"425g (15oz) shrimp, peeled and",
"POOP removed (measured raw)",
"550g zucchini, cut into strips",
"550g green cabbage, shredded",
"300g tomatoes, diced",
"550g yellow squash, cut into strips",
"300g carrots, cut into strips",
"5 garlic cloves, minced",
"50g yellow onion, minced",
"Zest and juice of 5 lemons",
"Salt & pepper to taste",
"75ml (5 tbsp) water"
}',
'{
"Heat a skillet over medium-high heat. Spray with cooking spray. Add all of the vegetables, and toss with salt and pepper. Once the vegetables are mostly cooked, add the shrimp and sauté until mostly cooked.",
"Pre-heat the oven to 400°F (204°C). Spray a baking sheet with cooking spray, and then lay the tilapia flat on the baking sheet.",
"Pour lemon juice and zest over the fillets.",
"Transfer the sautéed vegetables and shrimp to the top of the tilapia filets.",
"Place all in the oven for 8-12 minutes, or until the tilapia is fully cooked.",
"Remove the fish and vegetables from the oven, and plate and serve. Enjoy!"
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
380,
5,
30,
8,
57,
5
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'NuPasta Chicken Stirfry',
10,
25,
'{
"MAKES 1 SMALL SERVING",
"1 package of NuPasta (35 calories)",
"125g (1⁄2 cup) pasta sauce (up to 60 calories)",
"90g chicken breast (measured cooked)",
"1⁄2 serving veggies (50 calories)",
"Spices/condiments to taste",
"Cooking spray"
}',
'{
"Cook NuPasta according to package instructions, and set aside.",
"Heat a pan over medium heat. Spray pan with cooking spray. Add veggies and chicken to pan and sauté until it is cooked through. Add spices to taste.",
"Add cooked nupasta and pasta sauce to the pan and sauté all together for a few minutes.",
"Serve and eat altogether in a bowl."
}',
FALSE,
FALSE,
TRUE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
320,
6,
33,
15,
33,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Prosciutto-Wrapped Chicken & Veggies',
15,
35,
'{
"MAKES 4 SERVINGS",
"440g (~15 oz) chicken breast, boneless and skinless (measured raw)",
"4 slices (56g) prosciutto or ham (120 calories)",
"600g spinach leaves",
"300g red bell pepper, diced",
"4 garlic cloves, minced",
"Salt, pepper, & Italian seasoning to taste",
"240 mL (1 cup) water"
}',
'{
"Place the red bell peppers, spinach, garlic and water in the pan and cook over medium/high heat.",
"Steam the veggies until the water has evaporated, then turn off the heat.",
"Slice chicken breast horizontally in half.",
"If the chicken is underweight add small pieces of chicken until you have the correct amount.",
"Place saran wrap over the chicken and lightly pound it out till flat with whatever is available.",
"Remove the Saran Wrap unless you''re a Moron.",
"Season the chicken on both sides with a bit of salt, pepper and Italian seasoning to taste.",
"Cover the chicken with a slice of prosciutto. Then, lay the chicken with the prosciutto on the bottom and chicken on the top.",
"Lay the steamed veggies on top of the chicken.",
"Carefully fold the chicken/prosciutto over the veggies to seal everything inside.",
"Place the stuffed chicken into a casserole dish with the open side down.",
"Place the stuffed chicken in the oven at 350°F (177°C) for 16-18 minutes.",
"Put on a plate and eat slower than last time."
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
210,
4,
11,
5,
35,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Spicy Pork Chile Stew',
20,
45,
'{
"MAKES 4 SERVINGS",
"440g (16 oz) pork tenderloin, raw",
"80g jalapenos",
"500g vine tomatoes",
"2 tbsp minced garlic (or 8 garlic cloves, minced)",
"240g yellow onion, large diced",
"400 ml chicken stock",
"16g cilantro",
"Spices to taste: salt, black pepper, ground coriander"
}',
'{
"Preheat the oven to 400°F/204°C. Place the pork tenderloin on a baking tray and bake in the oven for 10-15 minutes till completely cooked through or the internal temperature of the pork is 145°F/63°C. Remove from the oven and set aside.",
"In a sauce pot, place the tomatoes, peppers, garlic and onions in the pot. Cover with water and boil over high heat for 10 minutes or until the veggies are soft and tender.",
"Remove from the heat and drain the liquid.",
"Place the cooked veggies in a blender with the salt, pepper, cilantro, coriander and chicken stock.",
"Blend until the mixture is smooth.",
"Transfer the green mixture back to a sauce pot and heat to medium heat. Continue to cook for 5 minutes then reduce to a low simmer. The soup should have reduced by this point and thickened slightly.",
"Chop the pork tenderloin up into small diced cuts and add to the green chile stew. Continue to cook at a low simmer for an additional 5 minutes. Remove from the heat and transfer to a bowl. Serve and enjoy!"
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
250,
5,
17,
4,
33,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Swedish Meatballs',
20,
40,
'{
"MAKES 23 SMALL BALLS (OR 23 SERVINGS)",
"900g (32 oz) lean ground turkey or beef, raw",
"160g Panko breadcrumbs",
"960 ml beef broth",
"30g (~4 tbsp) corn starch",
"60ml (4 tbsp) water",
"1-2 tsp of the following spices (to taste): salt, black pepper, garlic powder, onion powder, ground cinnamon, nutmeg",
"1⁄2 tsp clove (ground or whole)"
}',
'{
"In a large bowl, add the ground turkey, breadcrumbs, and spices. Mix together thoroughly to make sure the turkey meat gets all the seasonings.",
"Using an ice cream scoop, portion out the meatball mixture as desired. Form the balls in your hands by rolling them back and forth. Place them on a baking sheet tray that has been coated with cooking spray.",
"Preheat the oven to 400°F/204°C. Bake the meatballs in the oven for 20 minutes or until they are cooked all the way through or have an internal temperature of 165°F/74°C. Remove them from the oven and set aside to rest.",
"In a skillet, add the beef broth and heat over high heat. While the broth is heating up, mix the cornstarch and water together in a small bowl.",
"Once the beef broth is boiling, add the cornstarch/water mixture and whisk constantly until the sauce thickens slightly.",
"Reduce the heat to a low simmer and add the meatballs.",
"Once the sauce has thickened and the meatballs are covered in the gravy, transfer to a serving bowl and garnish with fresh chopped parsley. Serve with toothpicks so people can eat one at a time with them. Enjoy!"
}',
FALSE,
FALSE,
FALSE,
'dinner'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
95,
3,
7,
0,
8,
23
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Cauliflower Mashed Potatoes',
10,
30,
'{
"MAKES 8 SERVINGS",
"900g (2 lbs or ~6 medium) potatoes",
"900g (2 lbs) cauliflower florets",
"230g (1 cup) fat-free sour cream",
"9g (3 tsp) guar/xanthan gum",
"8g (2 tsp) baking powder",
"Spices to taste",
"Salt",
"Optional garnish:",
"1 tbsp chives or scallions, diced"
}',
'{
"Boil 4 liters (or 4 quarts) of water with salt over high heat. Once water starts to boil, reduce heat to medium to bring the water to a simmer. Add the potatoes and leave in pot until fully cooked through. Drain in a colander and add to Ninja blender.",
"Separately, cook the cauliflower in a boiling pot of water. Drain in a colander and add to Ninja blender.",
"Add baking powder, spices, half of the fat-free sour cream, and guar gum to Ninja blender and pulse blend until smooth.",
"Serve with the remaining fat-free sour cream and any preferred spices and garnish."
}',
TRUE,
FALSE,
TRUE,
'side'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
150,
0,
33,
8,
5,
8
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Cauliflower Rice',
10,
60,
'{
"MAKES 3 CUPS",
"700g cauliflower",
"4 liters water"
}',
'{
"Place the water and cauliflower in a large pot over high heat on the stove. Keep the cauliflower inside the pot until it cooks through and you can stick a fork through it.",
"Remove the cauliflower from the pot and strain in a collander to dry. Let stand for about 10 minutes.",
"Place the cauliflower in a blender and blend on high until it is shredded into little pieces.",
"Once dry, wrap the cauliflower in cheesecloth and squeeze out any additional liquid."
}',
FALSE,
FALSE,
FALSE,
'side'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
175,
1,
37,
18,
14,
3
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Egg White Fries',
10,
45,
'{
"MAKES 1 SERVING",
"175g russet potato or white potato of choice",
"115g sweet potato",
"120g (1⁄2 cup) egg whites",
"Salt and pepper (to taste)",
"Optional:",
"Any spice(s) you desire (garlic powder, vegetable seasoning, Club House, seasoning salt)"
}',
'{
"Pre-heat the oven to 400°F/204°C.",
"Cut the potatoes lengthwise into strips.",
"Place in a large bowl.",
"Pour the egg whites over the cut potatoes.",
"Sprinkle with salt and pepper and any additional seasonings you desire.",
"Place parchment paper on a baking sheet. Spray with cooking spray for 1 second, and then place the potato strips on the sheet.",
"Bake at 400°F/204°C. After 20 minutes, remove from the oven and move the potatoes around. Place the baking sheet back in the oven and let cook for another 10 minutes.",
"Remove the potato strips from the oven and allow to cool. Enjoy!"
}',
TRUE,
FALSE,
TRUE,
'side'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
330,
1,
61,
8,
20,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Inside-Out Baked Potatoes',
10,
45,
'{
"MAKES 1 SERVING",
"300g any white potato (1 large potato)",
"120g (1⁄2 cup) 0% fat Greek yogurt",
"45g (3 tbsp) salsa",
"1 slice (or 19g shredded) fat-free cheese (30 calories)",
"50g deli meat of choice (50 calories)",
"1 tbsp sliced green onion",
"Salt & pepper (to taste)"
}',
'{
"Pre-heat the oven to 350°F/177°C.",
"Slice the potatoes in half and cook in the microwave until fully cooked. You may also bake in the oven until completely cooked.",
"Scoop out the white part of the potato, and place into a separate bowl. Make sure the skin remains intact.",
"Mix inside white of potato, Greek yogurt, salsa, cheese, and deli meat until there is a smooth, even consistency.",
"Spray a baking sheet with cooking spray, and place the potato half skins on it. Spoon the potato mixture back into each of the potato skins, and place the baking sheet in the oven for 10 minutes.",
"Remove from the oven and serve. Top with green onion, cheese, & salt & pepper if desired."
}',
TRUE,
FALSE,
TRUE,
'side'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
450,
4,
74,
8,
32,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Apple Cinnamon Protein Rice Cakes',
10,
15,
'{
"MAKES 1 SERVING",
"6 rice cakes",
"Sliced apples (3⁄4 serving ~1 medium sized apple) (I use a Granny Smith apple)",
"33g (1 scoop) chocolate protein powder",
"12g (2 tbsp) powdered peanut butter (PB2)",
"30ml (2 tbsp) water",
"1 packet (or 2 tsp) sweetener",
"Cinnamon to taste"
}',
'{
"Mix the chocolate protein powder and powdered peanut butter in a bowl. Slowly add water to make a liquid paste consistency. Add sweetener if you desire more sweetness like.",
"Spread the liquid paste over the rice cakes.",
"Wash the apple and cut into thin slices, place on top of the rice cake.",
"Sprinkle with cinnamon. Enjoy!"
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
490,
7,
80,
10,
35,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate PB Chilled Rice Cakes',
10,
15,
'{
"MAKES 1 SERVING",
"3 original rice cakes",
"16g (1⁄2 scoop) chocolate protein powder",
"12g (2 tbsp) powdered peanut butter (PB2)",
"30ml (2 tbsp) water",
"OPTIONAL:",
"1 packet (2 tsp) sweetener",
"Add 30g banana, apple or strawberry"
}',
'{
"Mix the chocolate protein powder and peanut butter powder in a bowl. Add water slowly to make a liquid paste consistency. (You may add a packet of sweetener if you prefer a very sweet taste.)",
"Spread the liquid paste over the rice cakes.",
"Place on a plate and put in the freezer for approximately 10-15 minutes.",
"Remove from the freezer and top with fresh sliced strawberry, banana, or apple. Enjoy!"
}',
TRUE,
FALSE,
FALSE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
265,
3,
36,
3,
22,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Blueberry Protein Cookies',
15,
30,
'{
"MAKES 12 COOKIES (6 SERVINGS)",
"180g (11⁄2 cups) oat flour",
"100g (3 scoops) vanilla protein powder (390 calories, 75g protein)",
"250g (1 cup) 0% fat Greek yogurt",
"135g (3⁄4 serving) fresh blueberries",
"125ml (1⁄2 cup) low calorie syrup",
"5g (1 tsp) vanilla extract",
"4g (1 tsp) baking powder",
"5g (1 tsp) baking soda",
"1 tsp salt"
}',
'{
"Preheat the oven to 350°F (177°C) and spray a baking sheet with cooking spray.",
"In a bowl, mix all the dry ingredients together well. In a separate bowl, mix all the wet ingredients together well. Add the wet ingredients to the dry ingredients and combine until fully mixed throughout. Fold in the blueberries and mix gently.",
"Place small spoonfuls of the batter on the baking sheet 1-2 inches (3-5cm) apart. Place in the oven and bake for 8-10 minutes or until the cookies begin to turn golden brown. Remove from the oven and allow the cookies to cool down for 10 minutes before serving."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
230,
3,
28,
4,
22,
6
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Chip Brownie Cookie',
10,
20,
'{
"MAKES 10 SERVINGS",
"Whisk wet",
"1 large egg",
"48g (1⁄2 cup) powdered peanut butter (PB2)",
"6 packets (1⁄4 cup) sweetener",
"30g (2 tbsp) unsweetened applesauce",
"Mix dry",
"50g (11⁄2 scoops) chocolate protein powder",
"16g (2 tbsp) self-rising flour",
"20g (1⁄4 cup) cocoa powder",
"5g (1 tsp) baking soda",
"Mix-ins",
"30g (2 tbsp) mini sugar-free chocolate chips"
}',
'{
"Preheat the oven to 350°F/177°C.",
"In a bowl, whisk together all the wet ingredients.",
"In another bowl, mix the dry ingredients together.",
"Gradually add the dry ingredients into the wet and mix thoroughly until smooth. Then add in the chocolate chips.",
"Using a spoon, drop 10 cookies onto parchment/splat mat (the cookies will spread a little).",
"Bake for 6-8 minutes. Depending on your protein, the cooking time may vary. It''s best to undercook so they are fudgy.",
"Let it cool slightly and put on a cooling rack to prevent cookies from continuing to bake or dry out."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
80,
3,
7,
2,
7,
10
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Cookie Explosion',
15,
10,
'{
"MAKES 8 COOKIES (4 SERVINGS)",
"60g (1⁄4 cup) egg whites",
"72g (3⁄4 cup) powdered peanut butter (PB2)",
"4 packets (~ 2 tbsp) sweetener",
"30g (2 tbsp) unsweetened applesauce",
"50g (11⁄2 scoops) chocolate protein powder",
"16g (2 tbsp) self-rising flour",
"20g (1⁄4 cup) cocoa powder",
"5g (1 tsp) baking soda",
"15g mini sugar-free chocolate chips"
}',
'{
"Preheat the oven to 350°F (177°C) and spray a baking sheet with cooking spray.",
"In a bowl, mix all the dry ingredients together well. In a separate bowl, mix all the wet ingredients together well. Add the wet ingredients to the dry ingredients and combine until fully mixed. Fold in the mini chocolate chips and mix gently.",
"Place 8 small spoonfuls of the batter on the baking sheet 1-2in (2-5 cm) apart. Place in the oven and bake for 5-7 minutes or until the cookies begin to turn golden brown. Remove from the oven and allow the cookies to cool down for 10 minutes before serving."
}',
TRUE,
FALSE,
FALSE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
170,
4,
23,
12,
20,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Cinnamon Raisin Squares',
15,
40,
'{
"MAKES 12 COOKIES",
"180g (3⁄4 cup) egg whites",
"570g (21⁄3 cup) unsweetened apple sauce",
"24 packets (1 cup) sweetener",
"300g (9 scoops) cinnamon or vanilla protein powder",
"120g raisins",
"7.5g (11⁄2 tsp) baking powder",
"~ 4g (3⁄4 tsp) baking soda",
"12g (2 tbsp) cinnamon",
"~ 4g (3⁄4 tsp) nutmeg"
}',
'{
"Preheat the oven to 325°F (163°C).",
"Combine all wet ingredients into a bowl and whisk and set aside.",
"In a separate large bowl, combine all dry ingredients and stir, then add wet ingredients and stir until smooth consistency.",
"Spray a loaf pan with cooking spray. Pour the batter into the loaf pan and bake for 25-30 minutes or until a toothpick comes out clean."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
155,
2,
16,
1,
21,
12
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Double Chocolate Cookie Squares',
20,
40,
'{
"MAKES 8 SERVINGS",
"60g (5⁄8 cup) powdered peanut butter (PB2)",
"66g (2 scoops) chocolate protein powder",
"375g chickpeas (canned, rinsed)",
"60g (1⁄4 cup) egg whites",
"30g (2 tbsp) sugar-free chocolate chips",
"60ml (1⁄4 cup) low-calorie syrup",
"5g (1 tsp) vanilla extract",
"2 packets (~1 tbsp) sweetener",
"2g (1⁄2 tsp) baking powder",
"1⁄4 tsp sea salt",
"Cooking spray"
}',
'{
"Preheat the oven to 350°F (177°C) and spray a baking sheet with cooking spray.",
"Place all ingredients (except the chocolate chips) in a blender and blend until smooth. Then, add the chocolate chips and mix with a spatula until well mixed.",
"Spray a square pan with cooking spray for 1 second. Spread the batter in the square pan.",
"Place the pan in the oven and bake for 15-17 minutes or until a toothpick comes out clean.",
"Remove from the oven and allow the cookie bake to cool down for 10 minutes.",
"Cut into 8 pieces or however many servings are desired."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
150,
4,
17,
4,
14,
8
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Pumpkin Protein Squares',
10,
40,
'{
"MAKES 1 BATCH. SERVING SIZE VARIES DEPENDING ON HOW LARGE OR SMALL YOU CUT THE PIECES.",
"60g (5⁄8 cup) powdered peanut butter (PB2)",
"66g (2 scoops) protein powder",
"250g (1 cup) pure pumpkin",
"2.5g (1⁄2 tsp) baking powder",
"1⁄4 tsp sea salt",
"5g (1 tsp) vanilla extract",
"375g chickpeas (canned, rinsed)",
"20g sugar-free chocolate chips",
"60g (1⁄4 cup) egg whites",
"110g banana",
"125g (1⁄2 cup) 0% fat cottage cheese",
"60ml (1⁄4 cup) Walden Farms sugar-free chocolate syrup",
"2 packets (~1 tbsp) sweetener",
"Cooking spray"
}',
'{
"Pre-heat the oven to 350°F (177°C).",
"Place all ingredients into a blender and blend on medium until smooth.",
"Spray a mixing bowl for 1 second with cooking spray. Add the mixture to the bowl and fold in the chocolate chips.",
"Spray an 8inx 8in (20 cm x 20 cm) square pan with cooking spray for 1 second. Spread the mixture with the chocolate chips in the square pan.",
"Place in the oven and bake until a toothpick comes out clean (approximately 45 minutes.)",
"Remove from the oven and let sit to cool completely and firm up.",
"Slice according to your preferred portion sizes and serve!"
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
125,
3,
15,
3,
11,
12
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Cottage Cookie Cakes',
20,
40,
'{
"MAKES 20 COOKIES",
"60g (5⁄8 cup) powdered peanut butter (PB2)",
"66g (2 scoops) chocolate protein powder",
"2g (1⁄2 tsp) baking powder",
"1⁄4 tsp salt",
"10g (2 tsp) vanilla extract",
"375g chickpeas (canned, rinsed)",
"20g sugar-free chocolate chips",
"60g (1⁄4 cup) egg whites",
"110g banana (1 serving)",
"125g (1⁄2 cup) 0% fat cottage cheese",
"80g (1⁄3 cup) Walden Farms chocolate syrup",
"2 packets (~1 tbsp) sweetener",
"Cooking spray"
}',
'{
"Preheat the oven to 350°F/177°C.",
"In a bowl, place the powdered peanut butter, cottage cheese combine all the ingredients. Mix well until there is a smooth consistency.",
"Fold the chocolate chips into the batter.",
"Spray a cookie sheet with cooking spray. With your hands, form 20 balls with the dough and place on a cookie sheet, leaving about 1in (~2cm) in between each dough ball.",
"Place in the oven and bake until the toothpick inserted into the middle comes out clean (approximately 15-17 minutes.)",
"Let sit to cool completely to firm up."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
70,
1,
8,
1,
6,
20
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'PB Chocolate Chip Banana Protein Cookies',
15,
40,
'{
"MAKES 4-8 COOKIES",
"66g (2 scoops) chocolate peanut butter whey protein powder",
"60g (1⁄4 cup) IMO syrup such as Vitafiber",
"60g (~1⁄2 cup) oat flour",
"24g (1⁄4 cup) powdered peanut butter (PB2)",
"25g (5 tbsp) cocoa powder",
"80ml (1⁄3 cup) unsweetened almond milk",
"10 packets (3⁄8 cup) sweetener",
"~1g (1⁄4 tsp) baking powder",
"60g (1⁄4 cup) egg whites",
"30g (~1⁄4 serving) overripe banana",
"60ml (1⁄4 cup) Walden Farms chocolate syrup",
"15g chocolate chips (80 calories)",
"Cooking spray"
}',
'{
"Preheat the oven to 375°F (190°C).",
"Mix all dry ingredients together in a bowl.",
"In a separate bowl, combine almond milk and vitafiber, stir and then heat in the microwave for 45 seconds.",
"Add the syrup/almond milk and egg white/banana to the dry mix, and stir until it forms a consistent paste.",
"Spray the cookie sheet with cooking spray. With your hands, shape 4-8 dough balls, and place on the cookie sheet 2in (5cm) apart from each other.",
"Place the chocolate chips evenly on each cookie.",
"Place in the oven for 12 min. Remove and let cool until you are ready to serve.",
"Eat warm or cold. I like it warm better!"
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
150,
3,
24,
11,
13,
6
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'PB Chocolate Chip Protein Cookies',
15,
40,
'{
"MAKES 4-8 COOKIES",
"66g (2 scoops) chocolate peanut butter whey protein powder",
"60g (1⁄4 cup) IMO syrup such as Vitafiber",
"60g (~1⁄2 cup) oat flour",
"24g (1⁄4 cup) powdered peanut butter (PB2)",
"25g (5 tbsp) cocoa powder",
"80ml (1⁄3 cup) unsweetened almond milk",
"10 packets (3⁄8 cup) sweetener",
"1g (~1⁄4 tsp) baking powder",
"60g (1⁄4 cup) egg whites",
"60ml (1⁄4 cup) Walden Farms chocolate syrup",
"15g chocolate chips (80 calories)",
"Cooking spray"
}',
'{
"Preheat the oven to 375°F (190°C).",
"Mix all dry ingredients together in a bowl.",
"In a separate bowl, combine almond milk and vitafiber, stir and then heat in the microwave for 45 seconds.",
"Add the syrup/almond milk and egg whites to the dry mix, and stir until it forms a consistent paste.",
"Spray the cookie sheet with cooking spray. With your hands, shape 4-8 dough balls, and place on the cookie sheet 2in (5cm) apart from each other.",
"Place the chocolate chips evenly on each cookie.",
"Place in the oven for 12 min. Remove and let cool until you are ready to serve.",
"Eat warm or cold. I like it warm better!"
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
146,
3,
22,
11,
13,
6
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Banana Fiber One Chocolate Protein Bar',
20,
120,
'{
"MAKES 1 BATCH (8 LARGE, 12 MEDIUM, 18 SMALL, OR 30 BITE-SIZE PIECES)",
"231g (7 scoops) chocolate peanut butter whey protein powder",
"315g/ml (~11⁄3 cup) IMO syrup such as Vitafiber syrup",
"220g (2 servings) overripe banana",
"60g Fiber One Original Bran cereal (120 calories)",
"Cooking spray"
}',
'{
"Microwave IMO syrup in a bowl until bubbles start to form (about 1 minute on high).",
"Remove bowl from microwave and add remaining ingredients. Combine all the ingredients together with a mixer or spoon until you achieve a sticky, doughy consistency.",
"Spread mixture onto a silicone tray and transfer to a freezer. Pro Tip: To help transfer the gooey mixture, I recommend that you spray one of your fingers with cooking spray to help to evenly distribute across the tray.",
"After about 1 hour in the freezer, remove the tray and let sit at room temperature for 5 minutes. Slice the batch into portion sizes of choice (for reference on the nutrition by portion size, see the nutrition table). Wrap individual pieces in wax paper and return them to the freezer.",
"Chocolate bars should remain in the freezer until they are ready to be eaten. Eat within 5 minutes of removing from the freezer for best results."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
150,
2,
30,
7,
15,
12
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Caramel Protein Chocolate Bar',
10,
120,
'{
"MAKES 1 BATCH. SERVING SIZE VARIES DEPENDING ON HOW LARGE OR SMALL YOU CUT THE PIECES.",
"264g (8 scoops) chocolate peanut butter protein powder",
"315g (11⁄3 cup) IMO syrup such as Vitafiber syrup",
"120g (1⁄2 cup) Walden Farms",
"Caramel/Chocolate Syrup",
"1 tsp caramel extract",
"Cooking spray"
}',
'{
"Microwave IMO syrup in a bowl until bubbles start to form (about 30 seconds on high).",
"Remove bowl from microwave and add remaining ingredients. Combine all the ingredients together with a mixer or spoon until you achieve a sticky, doughy consistency.",
"Spread mixture onto a silicone tray and transfer to a freezer. Pro Tip: To help transfer the gooey mixture, I recommend that you spray one of your fingers with cooking spray to help to evenly distribute across the tray.",
"After about 1 hour in the freezer, remove the tray and let sit at room temperature for 5 minutes. Slice the batch into portion sizes of choice (for reference on the nutrition by portion size, see the nutrition table). Wrap individual pieces in wax paper and return them to the freezer.",
"Chocolate protein bars should remain in the freezer until they are ready to be eaten."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
136,
2,
22,
4,
17,
12
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Eva Dunbar''s Coconut Power Protein Bar',
20,
120,
'{
"MAKES 1 BATCH. SERVING SIZE VARIES DEPENDING ON HOW LARGE OR SMALL YOU CUT THE PIECES.",
"264g (8 scoops) chocolate protein powder",
"315g (11⁄3 cup) IMO syrup such as Liquid Vitafiber",
"30g unsweetened coconut fine flakes",
"20g (1⁄4 cup) cocoa powder",
"110g Special K Protein Cereal",
"5g (1 tsp) coconut extract",
"1⁄2 tsp lemon rind",
"Cooking spray"
}',
'{
"Microwave liquid Vitafiber in a bowl until bubbles start to form (about 30 seconds on high).",
"Remove bowl from microwave and add remaining ingredients. Combine all the ingredients together with a mixer or spoon until you achieve a sticky, doughy consistency.",
"Spread mixture onto a silicone tray and transfer to a freezer. Pro Tip: To help transfer the gooey mixture, I recommend that you spray one of your fingers with cooking spray to help to evenly distribute across the tray.",
"After about 1 hour in the freezer, remove the tray and let sit at room temperature for 5 minutes. Slice the batch into portion sizes of choice (for reference on the nutrition by portion size, see the nutrition table). Wrap individual pieces in wax paper and return them to the freezer.",
"Coconut protein bars should remain in the freezer until they are ready to be eaten."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
190,
4,
30,
5,
19,
12
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Holiday Chocolate Protein Bar',
20,
120,
'{
"MAKES 1 BATCH. SERVING SIZE VARIES DEPENDING ON HOW LARGE OR SMALL YOU CUT THE PIECES.",
"264g (8 scoops) chocolate peanut butter whey protein powder",
"315g (11⁄3 cup) IMO syrup such as Vitafiber syrup",
"120ml (1⁄2 cup) Walden Farms Chocolate Syrup",
"20g (1⁄4 cup) cocoa powder",
"45g Christmas colored chocolate chips",
"5g (1 tsp) caramel extract (or peppermint extract)",
"Cooking spray"
}',
'{
"Microwave IMO syrup in a bowl until bubbles start to form (about 30 seconds on high).",
"Remove bowl from microwave and add remaining ingredients. Combine all the ingredients together with a mixer or spoon until you achieve a sticky, doughy consistency.",
"Spread mixture onto a silicone tray and transfer to a freezer. Pro Tip: To help transfer the gooey mixture, I recommend that you spray one of your fingers with cooking spray to help to evenly distribute across the tray.",
"After about 1 hour in the freezer, remove the tray and let sit at room temperature for 5 minutes. Slice the batch into portion sizes of choice (for reference on the nutrition by portion size, see the nutrition table at the bottom right of this page). Wrap individual pieces in wax paper and return them to the freezer.",
"Chocolate bars should remain in the freezer until they are ready to be eaten. Eat within 5 minutes of removing from the freezer for best results."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
153,
3,
25,
4,
17,
12
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Protein PB Chocolate Bar',
20,
120,
'{
"MAKES 1 BATCH. SERVING SIZE VARIES DEPENDING ON HOW LARGE OR SMALL YOU CUT THE PIECES.",
"230g (7 scoops) chocolate peanut butter cup whey protein powder",
"315g (11⁄3 cup) IMO syrup such as Vitafiber syrup",
"120ml (1⁄2 cup) Walden Farms chocolate syrup",
"20g (4 tbsp) cocoa powder",
"60g (5⁄8 cup) peanut butter powder (PB2)",
"Cooking spray"
}',
'{
"Microwave IMO syrup in a bowl until bubbles start to form (about 30 seconds on high).",
"Remove bowl from microwave and add remaining ingredients. Combine all the ingredients together with a mixer or spoon until you achieve a sticky, doughy consistency.",
"Spread mixture onto a silicone tray and transfer to a freezer. Pro Tip: To help transfer the gooey mixture, I recommend that you spray one of your fingers with cooking spray to help to evenly distribute across the tray.",
"After about 1 hour in the freezer, remove the tray and let sit at room temperature for 5 minutes. Slice the batch into portion sizes of choice* (see note). Wrap individual pieces in wax paper and return them to the freezer.",
"Chocolate bars should remain in the freezer until they are ready to be eaten. Eat within 5 minutes of removing from the freezer for best results."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
137,
3,
21,
10,
12,
12
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'SKOR Protein Bar',
20,
120,
'{
"MAKES 1 BATCH. SERVING SIZE VARIES DEPENDING ON HOW LARGE OR SMALL YOU CUT THE PIECES.",
"264g (8 scoops) chocolate peanut butter protein powder",
"315g (11⁄3 cup) IMO syrup such as Vitafiber syrup",
"80ml (1⁄3 cup) Walden Farms Caramel or Chocolate Syrup",
"20g (1⁄4 cup) cocoa powder",
"40g Skor chipits (toffee bits)",
"5g (1 tsp) caramel extract",
"Cooking spray"
}',
'{
"Microwave IMO syrup in a bowl until bubbles start to form (about 30 seconds on high).",
"Remove bowl from microwave and add remaining ingredients. Combine all the ingredients together with a mixer or spoon until you achieve a sticky, doughy consistency.",
"Spread mixture onto a silicone tray and transfer to a freezer. Pro Tip: To help transfer the gooey mixture, I recommend that you spray one of your fingers with cooking spray to help to evenly distribute across the tray.",
"After about 1 hour in the freezer, remove the tray and let sit at room temperature for 5 minutes. Slice the batch into portion sizes of choice (for reference on the nutrition by portion size, see the nutrition table). Wrap individual pieces in wax paper and return them to the freezer.",
"Chocolate protein bars should remain in the freezer until they are ready to be eaten."
}',
TRUE,
FALSE,
FALSE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
155,
3,
24,
4,
17,
12
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Special K Banana Crunch Chocolate Protein Bar',
20,
120,
'{
"MAKES 1 BATCH. SERVING SIZE VARIES DEPENDING ON HOW LARGE OR SMALL YOU CUT THE PIECES.",
"~230g (7 scoops) chocolate peanut butter whey protein powder",
"315ml (11⁄3 cup) IMO syrup such as Vitafiber syrup",
"220g (2 servings) overripe banana",
"110g Special K Protein Cereal",
"Cooking spray"
}',
'{
"Microwave IMO syrup in a bowl until bubbles start to form (about 30 seconds on high).",
"Remove bowl from microwave and add remaining ingredients. Combine all the ingredients together with a mixer or spoon until you achieve a sticky, doughy consistency.",
"Spread mixture onto a silicone tray and transfer to a freezer. Pro Tip: To help transfer the gooey mixture,  recommends that you spray one of your fingers with cooking spray to help to evenly distribute across the tray.",
"After about 1 hour in the freezer, remove the tray and let sit at room temperature for 5 minutes. Slice the batch into portion sizes of choice (for reference on the nutrition by portion size, see the nutrition table). Wrap individual pieces in wax paper and return them to the freezer.",
"Chocolate bars should remain in the freezer until they are ready to be eaten. Eat within 5 minutes of removing from the freezer for best results."
}',
TRUE,
FALSE,
FALSE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
186,
2,
40,
29,
17,
12
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Double Chocolate Protein Popcorn',
10,
20,
'{
"MAKES 2 SERVINGS",
"2 bags SmartPop popcorn (~400 calories - because not all kernels pop)",
"80g (1/3 cup) IMO syrup such as Vitafiber",
"50g (11⁄2 scoop) chocolate protein powder",
"30g (2 tbsp) Walden Farms chocolate syrup or sugar-free chocolate syrup of choice",
"1 packet (2 tsp) sweetener"
}',
'{
"Pop popcorn in the microwave per directions. Once popped, place the popped popcorn in a larger bowl than last time. Remove all unpopped kernals (this makes a HUGE difference)!",
"Separately, put the IMO syrup in a microwave-safe bowl, and microwave for 30 seconds.",
"Add chocolate syrup, protein powder and sweetener to the IMO syrup and stir with a spoon.",
"Pour the syrup/protein powder mixture on top of the popped SmartPop, and carefully mix with a spatula until well combined NOTE: It can take some work to get the popcorn evenly coated. If you don''t mind getting a little messy use your hands!",
"Place and store the chocolate popcorn in the freezer. Eat half now and save the rest for later if you can!! (Although you might not be able to... these are crazy good!)"
}',
TRUE,
TRUE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
370,
5,
7,
17,
24,
2
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Extra Anabolic Protein Popcorn',
10,
20,
'{
"MAKES 2 SERVINGS",
"1 bag SmartPop popcorn (~200 calories - because not all kernels pop)",
"80g (1/3 cup) IMO syrup such as Vitafiber",
"50g (11⁄2 scoop) protein powder, flavor of choice",
"38g (21⁄2 tbsp) Walden Farms chocolate syrup OR 30g (2 tbsp) sugar-free maple syrup"
}',
'{
"Pop popcorn in the microwave per directions. Once popped, place the popped popcorn in a large bowl. Remove all unpopped kernals (this makes a HUGE difference)!",
"Separately, put the IMO syrup and the Walden Farms syrup in a microwave-safe bowl, and microwave for 30 seconds.",
"Add chocolate syrup and protein powder to the bowl of IMO syrup and stir with a spoon.",
"Pour the syrup/protein powder mixture on top of the popped SmartPop, and carefully mix with a spatula until well combined NOTE: It can take some work to get the popcorn evenly coated. If you don''t mind getting a little messy use your hands!",
"Place and store the coated popcorn in the freezer. Eat half now and save the rest for later if you can!! (Although you might not be able to... these are crazy good!)"
}',
TRUE,
TRUE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
270,
4,
55,
12,
22,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Protein Popcorn',
10,
20,
'{
"MAKES 2 SERVINGS",
"1 bag SmartPop popcorn (~200 calories - because not all kernels pop)",
"60g (1/4 cup) IMO syrup such as Vitafiber",
"33g (1 scoop) protein powder, flavor of choice",
"30g (2 tbsp) sugar-free maple syrup of choice"
}',
'{
"Pop popcorn in the microwave per directions. Once popped, place the popped popcorn in a large bowl. Remove all unpopped kernals (this makes a HUGE difference)!",
"Separately, put the IMO syrup in a microwave-safe bowl, and microwave for 30 seconds.",
"Add the sugar-free maple syrup and protein powder scoops to the bowl of liquid IMO syrup, and mix with a spoon until even throughout.",
"Pour the syrup/protein powder mixture on top of the popped SmartPop, and carefully mix with a spatula until well combined NOTE: It can take some work to get the popcorn evenly coated. If you don''t mind getting a little messy use your hands!",
"Place and store the coated popcorn in the freezer. Eat half now and save the rest for later if you can!! (Although you might not be able to... these are crazy good!)"
}',
TRUE,
TRUE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
220,
4,
46,
9,
15,
2
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Apple Poop',
15,
35,
'{
"MAKES 1 SERVING",
"45g (1⁄2 cup) rolled oats",
"570g (3 servings) apples",
"6 packets (1/4 cup) sweetener",
"9g (3 tsp) guar gum",
"1 - 11⁄2 tsp cinnamon",
"1 liter of water"
}',
'{
"Chop apples into medium cubes.",
"Add apples, oats, sweetener, and cinnamon to a large microwave-safe bowl and toss with a fork.",
"Blend water and guar gum on high for 15 seconds.",
"Add blended water and guar gum mixture to the microwave-safe container, and stir all ingredients with a fork.",
"Place the bowl in the microwave and heat on high. Remove the bowl from the microwave and add water and stir as needed until apples are very soft (or as soft as you want them to be.) This may take anywhere from 10-40 minutes depending on how strong your microwave is and how mushy you want your apples to be!"
}',
TRUE,
TRUE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
450,
3,
108,
22,
6,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Banana Chocolate Protein Donuts',
20,
40,
'{
"MAKES 4 SERVINGS",
"220g (2 servings) banana",
"125g (1⁄2 cup) 0% fat Greek yogurt",
"180g (3⁄4 cup) egg whites",
"95g (~3⁄4 cup) flour of choice",
"132g (4 scoops) chocolate protein powder",
"5g (1 tsp) baking soda",
"4g (1 tsp) baking powder",
"5g (1 tsp) vanilla extract"
}',
'{
"Preheat the oven to 350°F (177°C)",
"Add the banana and yogurt in a blender and blend till smooth.",
"Add in the rest of the ingredients and blend again until everything is well mixed.",
"Spray a donut pan with cooking spray. Fill the donut pan 1⁄2 - 3⁄4 full and bake for approximately 10 minutes.",
"Once done, let cool for approximately 1 minute, take the doughnuts out of the molds and let them cool on a wire rack."
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
325,
3,
42,
3,
37,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Low-Calorie Brownie',
20,
60,
'{
"MAKES 12 BROWNIES",
"60ml (1⁄4 cup) low-calorie syrup",
"240ml (1 cup) unsweetened almond milk",
"5g (1 tsp) vanilla extract",
"12 packets (or ~1⁄2 cup) sweetener",
"Cooking spray",
"MIX DRY:",
"48g (1⁄2 cup) powdered peanut butter (PB2)",
"90g (3⁄4 cup) all-purpose flour",
"5g (1 tsp) baking powder",
"Pinch of salt",
"FUDGE SAUCE:",
"15g (3 tbsp) cocoa powder",
"18g (3 tbsp) powdered peanut butter (PB2)",
"60ml (1⁄4 cup) low calorie syrup",
"60ml (1⁄4 cup) hot water"
}',
'{
"Pre-heat the oven to 350°F (177°C).",
"Place all ingredients in the blender except for the fudge sauce. Blend until there is a smooth consistency.",
"Spray a cake or brownie pan with cooking spray. Add the gooey brownie mixture to the pan, and spread evenly.",
"Place the brownie in the oven and bake at 350°F (177°C) for 25-30 minutes, or until a toothpick test comes out clean.",
"Remove the brownies from the oven, and let sit for about 10-15 minutes. Drizzle the fudge sauce on top of the brownie. Then, slice the brownie batch into portion sizes of choice (for reference on the nutrition by portion size, see the nutrition table at the bottom right of this page).",
"Serve and enjoy the mouth-watering chocolatey brownie!"
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
70,
2,
12,
2,
5,
12
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Peanut Butter Cupcakes',
20,
60,
'{
"MAKES 8 SERVINGS",
"60g (5⁄8 cup) powdered peanut butter (PB2)",
"66g (2 scoops) peanut butter protein powder",
"375g chickpeas (canned, rinsed)",
"20g sugar-free chocolate chips",
"60g (1⁄4 cup) egg whites",
"175g (3⁄4 cup) 0% fat Greek yogurt",
"15g (1 tbsp) vanilla extract",
"1⁄4 tsp sea salt",
"2 packets (~1 tbsp) sweetener",
"60ml (1⁄4 cup) Walden Farms syrup",
"1⁄2 tsp baking powder"
}',
'{
"Pre-heat the oven to 350°F (176°C).",
"Blend all ingredients except for chocolate chips until smooth",
"Add in chocolate chips and mix in by hand",
"Add the mixture into a cupcake pan or a regular baking pan.",
"Bake at 350°F (176°C) for 15-17 minutes or until you can stick a toothpick into the cupcake and the toothpick comes out clean.",
"Let sit to cool completely to firm up"
}',
TRUE,
FALSE,
TRUE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
165,
4,
18,
4,
16,
8
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Protein Cinnamon Roll',
20,
45,
'{
"MAKES 1 SERVING",
"DOUGH:",
"30g (1⁄4 cup) self-rising flour",
"15g (~1⁄2 scoop) cinnamon or vanilla protein powder",
"60g (~1⁄4 cup) 0% fat Greek yogurt",
"FILLING:",
"30ml (2 tbsp) low calorie syrup",
"2.5g (1⁄2 tsp) cinnamon",
"2.5g (1⁄2 tsp) sweetener",
"GLAZE:",
"16g (~1⁄2 scoop) vanilla protein powder",
"45ml (3 tbsp) sugar-free syrup (to taste)"
}',
'{
"Preheat the oven to 350°F (177°C)",
"Add all dough ingredients to a large bowl. Whisk until dough begins to form dough (it will be sticky). With your hands, roll the dough into a ball and let sit.",
"Place the dough on a floured surface and spread out into a long rectangle using wet fingers.",
"Spread the filling over the dough, then roll into a log. (May need a butter knife to help roll if sticking to the surface)",
"Place roll onto a sprayed mug and drizzle any leftover filling over it.",
"Bake for approximately 15-20 minutes, checking for doneness after 15 minutes.",
"Remove from the oven when done baking. Let sit for 2-3 minutes before eating."
}',
TRUE,
FALSE,
FALSE,
'snack'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
335,
2,
46,
1,
35,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Anabolic Avalanche',
10,
20,
'{
"MAKES 1 SMALL SERVING",
"Chocolate Cake Chunks:",
"16g (1⁄2 scoop) protein powder (65 calories)",
"5g (1 tbsp) cocoa powder",
"1.5g (1⁄2 tsp) guar/xanthan gum",
"15ml (1 tbsp) water",
"Shake/Ice Cream:",
"33g (1 scoop) vanilla protein powder (130 calories)",
"1.5g (1⁄2 tsp) guar/xanthan gum",
"1⁄2 serving frozen fruit of choice (50 cals.)",
"60ml (1⁄4 cup) unsweetened almond milk",
"1 packet (2 tsp) sweetener",
"Ice",
"TOP WITH:",
"15ml (1 tbsp) sugar-free chocolate sauce (5 calories)"
}',
'{
"Mix all ingredients for the Chocolate Cake Chunks in a microwave-safe bowl with a whisk until evenly mixed.",
"Microwave the batter for 60 seconds until it is cooked fully through and resembles a cake (note that microwave times may vary as they have different power - keep adding 10 seconds at a time until fully cooked through.)",
"Remove the cake from the bowl and cut into bite-sized chunks.",
"Next, place all of the ingredients for the shake/ice cream into a blender. Blend all together until the batter is very thick and smooth. You may need to scrape down the sides to ensure it blends perfectly.",
"Remove ice cream from the blender and place into a bowl. Add the lava cake chunk toppings as well as your low-calorie/sugar- free chocolate sauce to the top.",
"Eat immediately and try to not get brain freeze. Enjoy!"
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
185,
5,
20,
3,
40,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Protein Ice Cream Pudding',
10,
10,
'{
"MAKES 1 SERVING",
"50g (11⁄2 scoop) protein powder of choice",
"125g (1⁄2 cup) 0% fat Greek yogurt",
"90ml (3⁄8 cup) unsweetened almond milk",
"15g fat-free chocolate Jell-O pudding (50 calories)",
"15g (~2.5 tbsp) chocolate peanut butter powder (PB2)",
"7.5g (11⁄2 tbsp) cocoa powder",
"~2g (3⁄4 tsp) guar/xanthan gum",
"2 packets (4 tsp) sweetener",
"Ice"
}',
'{
"Add all ingredients to a blender. Blend for 1 minute on medium-high speed until there is a smooth consistency. Note that if you use casein protein, the protein ice cream pudding will be thicker.",
"Scrape sides of the blender and ensure all ingredients are blended. You may have to pulse the blender a few times depending on the consistency you want to achieve. You can always add more ice or water to get the consistency you desire.",
"Pour the mixture out of the blender and into a bowl to consume immediately. You may drizzle with powdered peanut butter, or fresh blueberries, or Walden Farms low-calorie syrup, or popcorn, anything that makes it more interesting and delicious for you. IT DOESN''T MATTER! There are NO rules in this kitchen! Just be sure that you account for your toppings when tracking your calories."
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
400,
8,
30,
5,
58,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Cottage Cheese Chocolate PB Delight',
0,
10,
'{
"MAKES 2 SERVINGS",
"500g (2 cups) 0% fat cottage cheese",
"720ml (3 cups) unsweetened almond milk (90 calories)",
"33g (1 scoop) chocolate peanut butter whey protein powder",
"24g (1/4 cup) powdered peanut butter (PB2)",
"1 packet fat-free sugar-free Jell-O chocolate pudding (140 calories)",
"6g (2 tsp) guar/xanthan gum",
"15g (3 tbsp) cocoa powder",
"10 packets (3⁄8 cup) sweetener (to taste)"
}',
'{
"Add all ingredients to a blender. Blend for 3 minutes on medium- high speed until there is a smooth consistency. Note that the more casein protein is used, the thicker the pudding will be.",
"Remove pudding from blender and transfer to an airtight refrigerator safe container. Pudding is ready to eat."
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
100,
2,
10,
2,
11,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Dairy Dream Protein Dessert with Cottage Cheese',
0,
10,
'{
"MAKES 1 SMALL SERVING",
"125g (1⁄2 cup) 0% fat cottage cheese",
"125ml (1⁄2 cup) Liquid Muscle or",
"Muscle Egg flavored egg whites (flavor of choice)",
"1⁄2 serving fruit (up to 50 calories)"
}',
'{
"Add all ingredients to a bowl, with cottage cheese at the bottom, then Liquid Muscle egg whites, then fruit.",
"Dessert is ready to eat."
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
195,
0,
18,
3,
25,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Fat-Free Chocolate Jell-O Protein Pudding',
0,
10,
'{
"MAKES 2 SERVINGS",
"360ml (11⁄2 cup) lactose-free protein milk (use the lactose free milk with the highest protein you can find! Mine has 13g of protein per cup!)",
"120 ml (1⁄2 cup) unsweetened almond milk",
"3g (1 tsp) guar/xanthan gum",
"33g (1 scoop) whey protein of choice",
"1 packet fat-free sugar-free chocolate Jell-O pudding (140 calories)"
}',
'{
"Add all ingredients to a blender. Blend for 3 minutes on medium- high speed until there is a smooth consistency.",
"Remove pudding from blender and transfer to an airtight refrigerator safe container. Pudding is ready to eat."
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
210,
2,
25,
2,
23,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Protein Mousse',
10,
15,
'{
"MAKES 1 SERVING",
"375g (11⁄2 cup) 0% fat Greek yogurt",
"33g (1 scoop) protein powder of choice",
"2 packets (4 tsp) sweetener",
"150g strawberries (1⁄2 serving)",
"15g (1 tbsp) Walden Farms chocolate syrup",
"TOPPINGS:",
"Top with berries and syrup"
}',
'{
"Mix the yogurt, protein powder, Walden Farms syrup, and sweetener together in a bowl.",
"Whip with a mixer for approximately 2 min until all of the ingredients are evenly blended and the mixture is fluffy.",
"Top with berries and any additional syrup. Serve and enjoy!"
}',
TRUE,
FALSE,
TRUE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
380,
3,
27,
3,
60,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Cottage Cheese Protein Pudding (Chocolate)',
5,
10,
'{
"MAKES 1 SINGLE HIGH PROTEIN MUG-CAKE.",
"500g (2 cups) 0% fat cottage cheese",
"~1L (41⁄2 cups) unsweetened almond milk",
"66g (2 scoops) chocolate protein powder",
"1 packet fat-free sugar-free chocolate",
"Jell-O pudding (140 calories)",
"13-18g (11⁄2-2 tbsp) guar/xanthan gum",
"10 packets (~6 tbsp) sweetener"
}',
'{
"Add all ingredients to a Ninja blender. Blend for 3 minutes on medium/high speed until there is a smooth consistency",
"Remove pudding from blender and transfer to an air-tight refrigerator safe container. Pudding is ready to eat."
}',
TRUE,
FALSE,
TRUE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
190,
3,
11,
3,
32,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Protein Lava Cake (Mega Batch)',
10,
15,
'{
"MAKES 1 MEGA BATCH. SERVING SIZE VARIES DEPENDING ON HOW MANY CALORIES YOU WANT",
"165g (5 scoops) chocolate protein powder",
"40g (1⁄2 cup) cocoa powder",
"360g (11⁄2 cup) egg whites",
"240ml (1 cup) water",
"12 packets (1⁄2 cup) sweetener (to taste)",
"6g (2 tsp) guar/xanthan gum",
"Cooking spray"
}',
'{
"Throw everything into a Ninja Blender and blend until smooth.",
"Spray 4-6 (depending on how many calories you want) microwave-safe mugs/containers with cooking spray for 1 second.",
"Pour batter into the 4-6 microwaveable mugs/containers, and microwave on high for 30 seconds (If not finished, cook for 10 seconds at a time). Do not overcook, ensure the centre is very gooey!"
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
167,
1,
7,
3,
28,
6
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Pumpkin Peanut Butter Cake',
20,
60,
'{
"MAKES 4 SERVINGS",
"60g (~5⁄8 cup) powdered peanut butter (PB2)",
"66g (2 scoops) chocolate protein powder",
"250g (~1 cup) pumpkin purée",
"2g (1⁄2 tsp) baking powder",
"2.5g (1⁄2 tsp) baking soda",
"1⁄4 tsp sea salt",
"5g (1 tsp) vanilla extract",
"80g (1⁄3 cup) egg whites",
"125g (1⁄2 cup) 0% fat cottage cheese",
"130g chickpeas (cooked)",
"15 packets (5⁄8 cup) sweetener (to taste)"
}',
'{
"Preheat the oven to 350°F (177°C).",
"In a large bowl, mix all the dry ingredients together well. In a separate bowl, mix all the wet ingredients together. Add wet and dry ingredients together, and fully mix.",
"Spray a baking dish with cooking spray. Pour the batter in the greased pan and place in the oven. Bake the cake for 30-40 minutes or until fully cooked. Use a toothpick and insert it in the middle of the cake. If it comes out clean then it is done.",
"Remove the cake from the oven and let it cool for 30 minutes before cutting and serving."
}',
TRUE,
FALSE,
TRUE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
230,
3,
23,
6,
26,
4
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Protein Mug Cake',
5,
10,
'{
"MAKES 1 SINGLE HIGH PROTEIN MUG CAKE",
"33g (1 scoop) chocolate protein powder",
"5g (1 tbsp) cocoa powder",
"60ml/~60g (1⁄4 cup) egg whites",
"3 packets (2 tbsp) sweetener (to taste)",
"1g (~ 1⁄4 tsp) guar/xanthan gum",
"Cooking spray"
}',
'{
"Spray a mircowave-save mug/container with cooking spray. Add all ingredients (in any order) into the mug/container and stir with a spoon until batter is smooth",
"Place the mug/container into the microwave and cook on high for 30 seconds (If not finished, cook for 10 seconds at a time). Do not overcook, ensure the centre is still gooey!"
}',
TRUE,
FALSE,
TRUE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
180,
3,
7,
3,
30,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Vegan Chocolate Mug Cake',
5,
10,
'{
"MAKES 1 SINGLE HIGH PROTEIN MUG CAKE",
"50g (1.5 scoop) chocolate protein powder",
"5g (1 tbsp) cocoa powder",
"30ml (2 tbsp) Walden Farms Chocolate Syrup",
"30ml (2 tbsp) water",
"2 packets (4 tsp) sweetener (to taste)",
"1g (~1⁄4 tsp) guar/xanthan gum",
"Cooking spray"
}',
'{
"Spray a mircowave-save mug/container with cooking spray. Add all ingredients (in any order) into the mug/container and stir with a spoon until batter is smooth",
"Place the mug/container into the microwave and cook on high for 30 seconds (If not finished, cook for 10 seconds at a time). Do not overcook, ensure the centre is very gooey!"
}',
TRUE,
TRUE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
210,
2,
10,
4,
37,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Blueberry Protein Shake',
10,
10,
'{
"MAKES 1 SMALL SERVING",
"33g (1 scoop) protein powder of choice",
"45g (1⁄4 serving) frozen blueberries",
"1g (1⁄4 tsp) guar/xanthan gum",
"90ml (3⁄8 cup) unsweetened almond milk",
"Ice"
}',
'{
"Add all ingredients to a blender. Blend for 1 minute on medium-high speed until there is a smooth consistency. Note that if you use casein protein, the shake will be thicker.",
"Scrape sides of the blender and ensure all ingredients are blended. You may have to pulse the blender a few times depending on the consistency you want to achieve. You can always add more ice or almond milk to get the consistency you desire.",
"Pour the mixture out of the blender and into a mug to consume immediately. You may drizzle with powdered peanut butter, fresh blueberries, or Walden Farms low-calorie syrup."
}',
TRUE,
TRUE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
183,
3,
14,
4,
26,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Blueberry PB Protein Ice Cream',
10,
10,
'{
"MAKES 1 MEDIUM SERVING",
"50g (11⁄2 scoops) chocolate peanut butter protein powder",
"135g (3⁄4 serving) frozen blueberries",
"12g (2 tbsp) chocolate peanut butter powder (chocolate PB2)",
"~2g (3⁄4 tsp) guar/xanthan gum",
"90ml (3⁄8 cup) unsweetened almond milk",
"2 packet (4 tsp) sweetener",
"Ice"
}',
'{
"Add all ingredients to a blender. Blend for 1 minute on medium-high speed until there is a smooth consistency. Note that if you use casein protein, the ice cream will be thicker.",
"Scrape sides of the blender and ensure all ingredients are blended. You may have to pulse the blender a few times depending on the consistency you want to achieve. You can always add more ice or water to get the consistency you desire.",
"Pour the mixture out of the blender and into a bowl to consume immediately. You may drizzle with powdered peanut butter, or fresh blueberries, or Walden Farms low-calorie syrup, or popcorn, anything that makes it more interesting and delicious for you. IT DOESN''T MATTER! There are NO rules in this kitchen! Just be sure that you account for your toppings when tracking your calories."
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
355,
7,
33,
9,
44,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Fudge Brownie Protein Ice Cream',
10,
15,
'{
"MAKES 1 LARGE OR 2 SMALL SERVINGS",
"66g (2 scoops) fudge protein powder (260 calories, 50g protein)",
"20g (4 tbsp) cocoa powder",
"50g Fiber One Brownie Bar",
"4g (~11⁄4 tsp) guar gum",
"2 packets sweetener (4 tsp) OR ~1 tbsp Stevia/Erythritol",
"1⁄4 tsp salt",
"60g water",
"420g ice"
}',
'{
"Take the Fiber One Brownie bar and slice it into bite-sized chunks. Transfer the brownie chunks into a bowl and set aside.",
"Pour water, salt, guar gum, Stevia, fudge protein powder, cocoa powder, and ice into the blender. Blend for 1 minute on high. After 1 minute, make sure to scrape the sides and bottom so that all unblended ingredients are thoroughly incorporated. Blend again for 1 minute and 30 seconds on High. Consistency after blending should be a thick cream.",
"Place fudge ice cream mixture into a container. Take the brownie chunks and sprinkle on top for added flavor and crunch. Enjoy!"
}',
TRUE,
FALSE,
TRUE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
230,
6,
33,
16,
29,
2
);
INSERT INTO users_recipes(username,recipe_id)
		SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
		WHERE NOT EXISTS (
		  SELECT username, recipe_id FROM users_recipes
		    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
		);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate PB Protein Ice Cream',
10,
10,
'{
"MAKES 1 SERVING",
"50g (11⁄2 scoops) protein powder of choice",
"15g (~3 tbsp) chocolate PB powder",
"7.5g (11⁄2 tbsp) cocoa powder",
"90ml (3⁄8 cup) unsweetened almond milk",
"~2g (3⁄4 tsp) guar/xanthan gum",
"2 packets (4 tsp) sweetener",
"Ice"
}',
'{
"Add all ingredients to a blender. Blend for 1 minute on medium-high speed until there is a smooth consistency. Note that if you use casein protein, the ice cream will be thicker.",
"Scrape sides of the blender and ensure all ingredients are blended. You may have to pulse the blender a few times depending on the consistency you want to achieve. You can always add more ice or water to get the consistency you desire.",
"Pour the mixture out of the blender and into a bowl to consume immediately. You may drizzle with powdered peanut butter, or fresh blueberries, or Walden Farms low-calorie syrup, or popcorn, anything that makes it more interesting and delicious for you. IT DOESN''T MATTER! There are NO rules in this kitchen! Just be sure that you account for your toppings when tracking your calories."
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
280,
8,
16,
5,
45,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chunky Monkey Protein Ice Cream',
5,
15,
'{
"MAKES 2 SERVINGS",
"33g (1 scoop) chocolate peanut",
"butter protein powder (130 calories, 25g protein)",
"42g sugar-free Jello banana pudding mix",
"20g sugar-free chocolate chips",
"8g walnuts",
"14g banana chips",
"5g (~11⁄2 tsp) guar gum",
"2 packets sweetener (4 tsp) OR ~1 tbsp Stevia/Erythritol",
"2g salt",
"400g ice",
"80g water"
}',
'{
"In a Ziploc bag, crush the walnuts into tiny pieces. Set aside.",
"Place sugar-free chocolate chips into a small bowl. Microwave for 1 minute on high. You may stir with a spoon to thoroughly melt the chocolate. Set aside.",
"Next, place a piece of parchment paper on top of a plate.",
"Coat the banana chips with the melted chocolate using a spoonor spatula. (Note that you must act fast while the chocolate is still melted or it will not stick to the banana chips.) Place the chocolate glazed banana chips on the plate covered with parchment paper.",
"Sprinkle the crushed walnuts on top of the chips and place inside the refrigerator to cool.",
"Pour water, salt, guar gum, stevia, chocolate peanut butter protein, banana pudding mix, and ice in a blender. Blend for 1 minute on high. After 1 minute, make sure to scrape the sides and bottom so that all unblended ingredients are thoroughly incorporated. Blend again for 1 minute on high. Consistency after blending should be a thick cream.",
"Pour the banana ice cream mixture in a container and spread thoroughly. Get the chocolate glazed banana chips from the fridge and add them on top of the banana ice cream mixture. Add the remaining crushed walnuts and chocolate chips for that extra crunch. Enjoy!"
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
515,
18,
71,
20,
28,
2
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Coffee Toffee Bar Crunch Protein Ice Cream',
5,
10,
'{
"MAKES 1 LARGE OR 2 SMALL SERVINGS",
"66g (2 scoops) vanilla whey protein (260 calories, 50 protein)",
"35g Hershey''s Health Shell Topping",
"15g Heath Toffee Bits (Bits O Brickle)",
"4g (~11⁄4 tsp) guar gum",
"10g (2 tbsp) cocoa powder",
"70g Walden Farms Walnut Syrup",
"1 packets sweetener (2 tsp) OR ~1⁄2 tbsp Stevia/Erythritol",
"2.5g medium instant coffee",
"420g ice",
"11⁄2 g salt"
}',
'{
"In a blender, mix Walden Farms walnut syrup, salt, guar gum, stevia, vanilla whey protein powder, cocoa powder, medium instant coffee, and ice. Blend for 1 minute on High. After 1 minute, make sure to scrape the sides and bottom so that all unblended ingredients are thoroughly incorporated. Blend again for 1 minute on High. Consistency after blending should be a thick cream. Set aside.",
"Grab a container of your choice and glaze the insides and the bottom of the container with some of the Health Shell Topping syrup. Next, pour in your coffee ice cream mixture into the container and spread thoroughly.",
"Glaze over or mix in the rest of the Heath Shell Topping Syrup on top of the ice cream. Lastly, sprinkle the Heath Toffee Bits on top for added crunch. Enjoy!"
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
290,
14,
20,
3,
27,
2
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chill''d Protein Ice Cream',
5,
10,
'{
"MAKES 1 LARGE SERVING OR 2 SMALL SERVINGS",
"ICE CREAM:",
"50g (11⁄2) scoops peanut butter protein powder (225 calories, 33g protein)",
"45g powdered peanut butter (PB2)",
"7g Snyder''s Itty Bitty Mini pretzels",
"3g (1 tsp) guar gum",
"1 packet sweetener (2 tsp) OR ~1⁄2 tbsp Stevia/Erythritol",
"405g ice",
"115g water",
"1⁄2 tsp salt",
"CHOCOLATE FUDGE:",
"17g (1⁄2 scoop) chocolate protein powder (75 calories)",
"12g Hershey''s sugar-free syrup",
"5g (1 tbsp) cocoa powder",
"1g (1⁄4 tsp) guar gum",
"1⁄2 packet sweetener OR 1 tsp Stevia/Erythritol"
}',
'{
"To make the Chocolate Fudge, mix the sugar free syrup, chocolate protein powder, stevia, cocoa powder, and guar gum in a bowl. When all ingredients are thoroughly mixed, place the bowl in the freezer for 1 hour.",
"Next, make the peanut butter cream. Place the pretzels in a plastic bag, crush them thoroughly, and set aside. Then, in a bowl, mix the crushed pretzels with the remaining dry ingredients (salt, stevia, guar gum, powdered peanut butter, and peanut butter protein powder)",
"Add the water, ice and peanut butter ice cream mixture to a blender. Blend on high for 1 minute. After 1 minute, scrape down the sides/edges if needed. Blend again for 1 minute and 30 seconds on High. After blending, the consistency should be a thick cream.",
"Scoop out the peanut butter ice cream mixture into a container of your choice and place it inside the freezer for 10 minutes. After 10 minutes, take your peanut butter ice cream mixture out of the freezer along with the chocolate fudge.",
"Cut your Chocolate Fudge into small pieces and (optionally) dip them into more crushed pretzels for that extra crunch. Garnish the chocolate fudge chunks on top of your peanut butter ice cream. Optionally, you may add whole pretzels as desired and WaldenFarms Calorie Free Syrup for extra taste. Enjoy!"
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
240,
5,
17,
3,
30,
2
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Pumpkin Cheesecake Protein Ice Cream',
10,
15,
'{
"MAKES 2 SERVINGS",
"66g (2 scoops) vanilla protein powder (260 calories, 50g protein)",
"24g Jello Sugar-Free Cheesecake Pudding Powder (75 calories)",
"12g graham crackers",
"15g pumpkin spice pretzels",
"150g raw or canned pumpkin (not Pumpkin Pie Filling)",
"3g (1 tsp) guar gum",
"1g baking powder",
"3 packets sweetener (2 tbsp) OR ~11⁄2 tbsp Stevia/Erythritol",
"1g pumpkin pie spice",
"1g salt",
"100g water",
"420g ice"
}',
'{
"Mix the pure pumpkin, 1⁄2 scoop vanilla whey powder, baking powder, 8g Stevia, 1⁄2g pumpkin pie spice, a tiny pinch of salt thoroughly in a container. Microwave the mixture for 1 to 2 minutes or until you get an almost dry and crumbly consistency. Place the pumpkin crust in the fridge to cool.",
"Next, place the graham crackers in a ziplock bag and crush them. Set aside.",
"In a blender, pour the water, ice 1⁄2g pumpkin pie spice powder, salt, guar gum, 16g Stevia, 11⁄2 scoops vanilla protein powder, and sugar-free cheesecake pudding mix. Blend for 1 minute on high. After 1 minute, scrape down the edges so that the protein powder doesn''t stick to the sides of the blender, and incorporate thoroughly with the whole mixture. Blend again for 1 minute on high. After blending, the consistency should be a thick cream.",
"Get your Pumpkin Crust from the fridge. Pour Vanilla Pumpkin Ice Cream mixture on top of the Pumpkin Crust and spread it well.",
"Sprinkle crushed Graham Crackers on top and whole pretzels to garnish. Enjoy!"
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
260,
4,
29,
3,
27,
2
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Strawberry Protein Ice Cream',
10,
10,
'{
"MAKES 1 SERVING",
"50g (1 1⁄2 scoops) strawberry or protein powder of choice",
"225g frozen strawberries (3⁄4 serving)",
"125g (1⁄2 cup) 0% fat Greek yogurt",
"~2g (3⁄4 tsp) guar/xanthan gum",
"90ml (3⁄8 cup) unsweetened almond milk",
"2 packets (4 tsp) sweetener",
"Ice"
}',
'{
"Add all ingredients to a blender. Blend for 1 minute on medium-high speed until there is a smooth consistency. Note that if you use casein protein, the ice cream will be thicker.",
"Scrape sides of the blender and ensure all ingredients are blended. You may have to pulse the blender a few times depending on the consistency you want to achieve. You can always add more ice or water to get the consistency you desire.",
"Pour the mixture out of the blender and into a bowl to consume immediately. You may drizzle with powdered peanut butter, or fresh blueberries, or Walden Farms low-calorie syrup, or popcorn, anything that makes it more interesting and delicious for you."
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
350,
6,
28,
9,
47,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Vanilla PB Protein Ice Cream',
10,
10,
'{
"MAKES 1 MEDIUM SERVING",
"50g (11⁄2 scoops) protein powder of choice",
"12g (2 tbsp) powdered peanut butter (PB2)",
"125g (1⁄2 cup) 0% fat Greek yogurt",
"90ml (3⁄8 cup) unsweetened almond milk",
"15g serving fat-free vanilla Jell-o pudding (50 calories)",
"~2g (3⁄4 tsp) guar/xanthan gum",
"2 packets (4 tsp) sweetener",
"2 cups ice"
}',
'{
"Add all ingredients to a blender. Blend for 1 minute on medium- high speed until there is a smooth consistency. Note that if you use casein protein, the ice cream will be thicker.",
"Scrape sides of the blender and ensure all ingredients are blended. You may have to pulse the blender a few times depending on the consistency you want to achieve. You can always add more ice or water to get the consistency you desire.",
"Pour the mixture out of the blender and into a bowl to consume immediately. You may drizzle with powdered peanut butter, or fresh blueberries, or Walden Farms low-calorie syrup, or popcorn, anything that makes it more interesting and delicious for you. IT DOESN''T MATTER! There are NO rules in this kitchen! Just be sure that you account for your toppings when tracking your calories."
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
345,
6,
24,
7,
47,
NULL
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Strawberry Almond Proteinsicles',
20,
150,
'{
"MAKES 1 BATCH (APPROX. 4 MEDIUM SERVINGS)",
"240ml (1 cup) unsweetened almond milk",
"116g (31⁄2) scoops chocolate peanut butter whey protein powder",
"300g frozen strawberries (1 serving)",
"3g (1 tsp) guar/xanthan gum",
"1 package fat-free Jell-O chocolate pudding (140 calories)",
"125g (1⁄2 cup) 0% fat Greek yogurt",
"5 packets (~3 tbsp) sweetener (to taste)"
}',
'{
"Add all ingredients to a blender. Pulse blend on medium-high speed until there is a smooth consistency. You will likely need to take a spoon and push the ingredients down a few times. Note that the more casein protein is used, the thicker the pudding will be.",
"Remove pudding from blender and transfer across 4 popsicle trays. Transfer to a freezer.",
"Wait a few hours, and pop out the proteinsicles from the tray when you are ready to have a delicious frozen treat!"
}',
TRUE,
FALSE,
TRUE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
196,
3,
18,
4,
25,
4
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Chocolate Strawberry PB Proteinsicles',
20,
150,
'{
"MAKES 1 BATCH (APPROX. 4 LARGE SERVINGS)",
"320 ml (~11⁄4 cups) ice water",
"150g frozen strawberries (1⁄2 serving)",
"165g (5 scoops) chocolate peanut butter whey protein powder",
"250g (1 cup) 0% fat Greek yogurt",
"72g (3⁄4 cup) chocolate peanut butter powder (PB2)",
"3g (1 tsp) guar/xanthan gum",
"5 packets (~3 tbsp) sweetener (to taste)"
}',
'{
"Add all ingredients to a blender. Pulse blend on medium-high speed until there is a smooth consistency. You will likely need to take a spoon and push the ingredients down a few times. Note that the more casein protein is used, the thicker the pudding will be.",
"Remove pudding from blender and transfer across 4 popsicle trays. Transfer to a freezer.",
"Wait a few hours, and pop out the proteinsicles from the tray when you are ready to have a delicious frozen treat!"
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
303,
5,
21,
8,
45,
4
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Strawberry Cheesecake Proteinsicle',
10,
150,
'{
"MAKES 1 BATCH (APPROX. 4 LARGE SERVINGS)",
"360 ml (11⁄2 cups) unsweetened almond milk",
"180g (51⁄2 scoops) strawberry casein protein powder of choice",
"450g frozen strawberries (11⁄2 servings)",
"9g (3 tsp) guar/xanthan gum",
"175g (3⁄4 cup) 0% fat Greek yogurt",
"1 packet cheesecake fat-free Jell-O pudding (100 calories)",
"12 packets (1⁄2 cup) sweetener (to taste)"
}',
'{
"Add all ingredients to a blender. Pulse blend on medium-high speed until there is a smooth consistency. You will likely need to take a spoon and push the ingredients down a few times. Note that the more casein protein is used, the thicker the pudding will be.",
"Remove pudding from blender and transfer across 4 popsicle trays. Transfer to a freezer.",
"Wait a few hours, and pop out the proteinsicles from the tray when you are ready to have a delicious frozen treat!"
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
290,
4,
23,
7,
40,
4
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);





INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
VALUES((SELECT nextval('recipes_recipe_id_seq'::regclass)),
'Vanilla Berry Proteinsicles',
10,
150,
'{
"MAKES 1 BATCH (APPROX. 4 LARGE SERVINGS)",
"240 ml (1 cup) water",
"165g (5 scoops) vanilla protein powder",
"280g frozen mixed berries",
"3g (1 tsp) guar/xanthan gum",
"250g (1 cup) 0% fat Greek yogurt",
"10 packets (3⁄8 cup) sweetener (to taste)"
}',
'{
"Add all ingredients to a blender. Pulse blend on medium-high speed until there is a smooth consistency. You will likely need to take a spoon and push the ingredients down a few times. Note that the more casein protein is used, the thicker the pudding will be.",
"Remove pudding from blender and transfer across 4 popsicle trays. Transfer to a freezer.",
"Wait a few hours, and pop out the proteinsicles from the tray when you are ready to have a delicious frozen treat!"
}',
TRUE,
FALSE,
FALSE,
'dessert'
);
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
VALUES((SELECT recipe_name FROM recipes WHERE recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)),
255,
3,
21,
6,
38,
4
);
INSERT INTO users_recipes(username,recipe_id)
	SELECT 'Operator', (SELECT last_value FROM recipes_recipe_id_seq)
	WHERE NOT EXISTS (
	  SELECT username, recipe_id FROM users_recipes
	    WHERE username = 'Operator' AND recipe_id = (SELECT last_value FROM recipes_recipe_id_seq)
	);
/*NOTE: MASTER SCRIPT :: END OF FILE*/
