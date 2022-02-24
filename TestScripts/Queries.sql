/*DON'T FORGET 'OFFSET' AND 'LIMIT' WILL WORK HAND-IN-HAND FOR 'PAGE-FLIPS'*/
/*
INSERT INTO users_favorites(user_uid,recipe_id)
  SELECT '8a94964b-fb4f-4801-8426-ff7ba6496481', 100
  WHERE NOT EXISTS(
    SELECT user_uid, recipe_id FROM users_favorites
      WHERE user_uid = '8a94964b-fb4f-4801-8426-ff7ba6496481' AND recipe_id = 100
  );


INSERT INTO users(user_uid, first_name, last_name, username, date_reg, verified)
	VALUES(uuid_generate_v4(), 'Test', 'Dummy', 'FunnyReddit', NOW()::DATE, TRUE);
INSERT INTO users_ue(username, email)
	VALUES('FunnyReddit', 'Im@not.funny');
INSERT INTO users_ep(email, password)
	VALUES('Im@not.funny', 'password');

INSERT INTO users(user_uid, first_name, last_name, username, date_reg, verified)
	VALUES(uuid_generate_v4(), 'Test', 'Dummy', 'shit', NOW()::DATE, TRUE);
INSERT INTO users_ue(username, email)
	VALUES('shit', 'shit@my.pants');
INSERT INTO users_ep(email, password)
	VALUES('shit@my.pants', 'sad');


INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
	VALUES(9001, 'dummy1',-1,-1,'{"text","text"}','{"text","text"}',FALSE, FALSE, FALSE, 'other');
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
	VALUES('dummy1',-1,-1,-1,-1,-1,NULL);
INSERT INTO users_recipes(username,recipe_id)
  SELECT 'Operator', [queue_number/recipe_id]
  WHERE NOT EXISTS (
    SELECT username, recipe_id FROM users_recipes
      WHERE username = 'Operator' AND recipe_id = 9001
  );

INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
	VALUES(9002, 'dummy2',-1,-1,'{"text","text"}','{"text","text"}',FALSE, FALSE, FALSE, 'other');
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
	VALUES('dummy2',-12,-12,-12,-12,-12,NULL);
INSERT INTO users_recipes(username,recipe_id)
  SELECT 'Operator', 9002
  WHERE NOT EXISTS (
    SELECT username, recipe_id FROM users_recipes
      WHERE username = 'Operator' AND recipe_id = 9002
  );

INSERT INTO recipes(recipe_id, recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
	VALUES(9003, 'dummy3',-1,-1,'{"text","text"}','{"text","text"}',FALSE, FALSE, FALSE, 'other');
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
	VALUES('dummy3',-123,-123,-123,-123,-123,NULL);
INSERT INTO users_recipes(username,recipe_id)
  SELECT 'FunnyReddit', 9003
  WHERE NOT EXISTS (
    SELECT username, recipe_id FROM users_recipes
      WHERE username = 'FunnyReddit' AND recipe_id = 9003
  );

INSERT INTO users_favorites(user_uid,recipe_id)
  SELECT (SELECT user_uid FROM users WHERE username = 'FunnyReddit'), 9001
  WHERE NOT EXISTS(
    SELECT user_uid, recipe_id FROM users_favorites
      WHERE user_uid = (SELECT user_uid FROM users WHERE username = 'FunnyReddit') AND recipe_id = 9001
  );

INSERT INTO users_favorites(user_uid,recipe_id)
  SELECT (SELECT user_uid FROM users WHERE username = 'FunnyReddit'), 9002
  WHERE NOT EXISTS(
    SELECT user_uid, recipe_id FROM users_favorites
      WHERE user_uid = (SELECT user_uid FROM users WHERE username = 'FunnyReddit') AND recipe_id = 9002
  );

INSERT INTO users_favorites(user_uid,recipe_id)
  SELECT (SELECT user_uid FROM users WHERE username = 'FunnyReddit'), 9003
  WHERE NOT EXISTS(
    SELECT user_uid, recipe_id FROM users_favorites
      WHERE user_uid = (SELECT user_uid FROM users WHERE username = 'FunnyReddit') AND recipe_id = 9003
  );

SELECT * FROM recipes JOIN (SELECT recipe_id FROM users_favorites WHERE user_uid = '8a94964b-fb4f-4801-8426-ff7ba6496481') AS fav USING (recipe_id) ORDER BY recipe_name DESC LIMIT 30;
*/
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    */
/*--|| INSERTION ||--*//*--|| INSERTION ||--*//*--|| INSERTION ||--*//*--|| INSERTION ||--*//*--|| INSERTION ||--*//*--|| INSERTION ||--*//*--|| INSERTION ||--*//*--|| INSERTION ||--*//*--|| INSERTION ||--*//*--|| INSERTION ||--*/
/*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    *//*    --||===||--    */
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/

/*User Registration Data Insertion Order*/
INSERT INTO users(user_uid, first_name, last_name, username, date_reg, verified)
	VALUES(uuid_generate_v4(), '[First Name]', '[Last Name]', '[Username]', NOW()::DATE, FALSE);/*OPTIONAL IMAGE SERVER PATH*/
INSERT INTO users_ue(username, email)
	VALUES('[Username]', '[Email]');
INSERT INTO users_ep(email, password)
	VALUES('[Email]','[Password]');

  /*Upload a Recipe:
  NOTE: Users uploading a recipe will be need to be approved, becuase of this their recipe_id
  	will be negative. Becuase there are no recipes existing in the first place, SELECT MIN(recipe_id) FROM recipes;
  	cannot be used to determine their place in queue as there are no tuples in the table.
        To remedy this, there will be default data inserted from the admin.
  	After which SELECT MIN(recipes_id) FROM recipes; along with some C# calculations,
  	users' recipes can be put into queue, awaiting approval
  */
  /*NOTE: Make sure this insertion is mutex: Queuing*/
INSERT INTO recipes(recipe_name, prep_time, total_time, ingredients, directions, vegetarian, vegan, gluten_free, denomination)
	VALUES('[Recipe Name]',-1,-1,'ARRAY[]::TEXT','ARRAY[]::TEXT',FALSE, FALSE, FALSE, '[Choose from constraints]');/*OPTIONAL IMAGE SERVER PATH*/
INSERT INTO nutrition(recipe_name, calories, fat, carbs, fiber, protien, servings)
	VALUES('[Recipe Name]',-1,-1,-1,-1,-1,NULL);/*Number of servings are optional*/
/*Automatic insertion by the server*/
INSERT INTO users_recipes(username,recipe_id)
  SELECT '[username]', [queue_number/recipe_id]
  WHERE NOT EXISTS (
    SELECT username, recipe_id FROM users_recipes
      WHERE username = '[username]' AND recipe_id = [queue_number/recipe_id]
  );

  /*Users Favoriting Recipes
NOTE: Depending on implementation, recipe_id may change to recipe_name
      The insertion of user_uid may change depending on how cookies/acvtive user tracking
 	works.
*/
/*Click favorite button*/
INSERT INTO users_favorites(user_uid,recipe_id)
  SELECT [UUID], [recipe_id]
  WHERE NOT EXISTS(
    SELECT user_uid, recipe_id FROM users_favorites
      WHERE user_uid = [UUID] AND recipe_id = [recipe_id]
  );


/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    */
/*--|| SELECTIONS ||--*//*--|| SELECTIONS ||--*//*--|| SELECTIONS ||--*//*--|| SELECTIONS ||--*//*--|| SELECTIONS ||--*//*--|| SELECTIONS ||--*//*--|| SELECTIONS ||--*//*--|| SELECTIONS ||--*//*--|| SELECTIONS ||--*/
/*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    *//*    --||====||--    */
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/

/*Log-in*/
/*Username input*/
SELECT password FROM (users_ue JOIN users_ep USING (email)) AS auth_key
  WHERE username = '[USERNAME]';
/*Email input*/
SELECT password FROM users_ep
  WHERE email = '[EMAIL]';


/*Search specific key words*/
/*NOTE: The second SELECT just determines what it pulls, if ingredients it will only display ingredients, for * it will pull all, doesn't 'matter' becuase the where clause is what matters*/
SELECT * FROM (SELECT *, generate_subscripts(ingredients, 1) AS i FROM recipes) AS ing
  WHERE ingredients[i] ~* '.*[ARGS.*' LIMIT 30;


/*HAVE THE ORM DETERMINE HE QUEIRES, BUILD THEM ON A STRING THEN QUERY FOR REGEX*/
/*Serach titles using regex*/
SELECT * FROM recipes
  WHERE recipe_name ~* '.*[ARGS].*';


/*data pulls from search terms/search users*/
/*Landing page:: OFFSET and LIMIT may be required for each multiple page of recipes*/
/*Default numbered order*/
SELECT * FROM recipes
  ORDER BY recipe_id ASC LIMIT 30;
SELECT * FROM recipes
  ORDER BY recipe_id DESC LIMIT 30;
SELECT * FROM recipes
  ORDER BY recipe_name ASC LIMIT 30;
SELECT * FROM recipes
  ORDER BY recipe_name DESC LIMIT 30;


/*Recipe Page*/
SELECT * FROM (recipes JOIN nutrition USING (recipe_name))
  WHERE recipe_id = 100; /*Maybe pull username as well; "view creator"*/


/*Favorites Page*/
SELECT * FROM recipes
  JOIN (SELECT recipe_id FROM users_favorites WHERE user_uid = [ACTIVE UUID]) AS fav USING (recipe_id)
  ORDER BY recipe_id ASC LIMIT 30 ;
SELECT * FROM recipes
  JOIN (SELECT recipe_id FROM users_favorites WHERE user_uid = [ACTIVE UUID]) AS fav USING (recipe_id)
  ORDER BY recipe_name DESC LIMIT 30 ;


/*User created recipes*/
SELECT * FROM recipes
  JOIN (SELECT * FROM users_recipes WHERE username = '[USERNAME]') AS u_r USING (recipe_id)
  ORDER BY recipe_id ASC LIMIT 30;
SELECT * FROM recipes
  JOIN (SELECT * FROM users_recipes WHERE username = '[USERNAME]') AS u_r USING (recipe_id)
  ORDER BY recipe_name DESC LIMIT 30;


/*See number of recipes created by users*/
SELECT username, COUNT(*) AS recipes_created FROM users_recipes
  GROUP BY username;/*HAVING COUNT(*) >= 5 ORDER BY recipes_created DESC;*/


/*User profile :: Outsider view*/
SELECT * FROM users
  WHERE username = '[USERNAME]';
/*:: ADDITIONAL PULLS IF VIEWER IF THE USER THEMSELVES*/
SELECT * FROM users
  JOIN users_ue USING (username)
  WHERE username = '[USERNAME]' AND user_uid = [ACTIVE UUID];


/*ADMIN:: See number of favorites created by users*/
SELECT username, COUNT(*) AS recipes_favorited FROM (users JOIN users_favorites USING (user_uid))
  GROUP BY username
  WHERE [ACTIVE UUID] = '[ADMIN UUID]';/*HAVING COUNT(*) >= 5 ORDER BY recipes_favorited DESC;*/

/*ADMIN:: Search all info on users including email:: Additionally pull num of favorited and created recipes*/
SELECT * FROM (((users JOIN users_ue USING (username) AS u_i)
	LEFT JOIN (SELECT username, COUNT(*) AS recipes_created FROM users_recipes GROUP BY username) AS u_in USING (username)))
	LEFT JOIN (SELECT user_uid, COUNT(*) AS recipes_favorited FROM users_favorites GROUP BY user_uid) AS u_inf USING (user_uid) AS user_info
  WHERE [ACTIVE UUID] = '[ADMIN UUID]';


/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    */
/*--|| DELETION ||--*//*--|| DELETION ||--*//*--|| DELETION ||--*//*--|| DELETION ||--*//*--|| DELETION ||--*//*--|| DELETION ||--*//*--|| DELETION ||--*//*--|| DELETION ||--*//*--|| DELETION ||--*//*--|| DELETION ||--*/
/*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    *//*    --||==||--    */
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/**/
DELETE FROM users_favorites
  WHERE user_uid = [ACTIVE UUID] AND recipe_id = [ASSOCIATED RECIPE ID];

/*:: ADMIN*/
DELETE FROM recipes
  WHERE recipe_id = [ASSOCIATED RECIPE ID] AND [ACTIVE UUID] = '[ADMIN UUID]';
/*OR :: USER DELETES OWN RECIPE*/
DELETE FROM recipes
  WHERE recipe_id = [ASSOCIATED RECIPE ID] AND [ACTIVE UUID] = (SELECT user_uid FROM users JOIN users_recipes USING (username) WHERE recipe_id = [ASSOCIATED RECIPE ID]);

/*:: ADMIN*/
DELETE FROM users
  WHERE user_uid = '[CHOSEN USER UUID]' AND [ACTIVE UUID] = '[ADMIN UUID]';
/*OR :: USER DELETES OWN ACCOUNT*/
DELETE FROM users
  WHERE user_uid = '[CHOSEN USER UUID]' AND [ACTIVE UUID] = '[CHOSEN USER UUID]';


/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    */
/*--|| UPDATES ||--*//*--|| UPDATES ||--*//*--|| UPDATES ||--*//*--|| UPDATES ||--*//*--|| UPDATES ||--*//*--|| UPDATES ||--*//*--|| UPDATES ||--*//*--|| UPDATES ||--*//*--|| UPDATES ||--*//*--|| UPDATES ||--*//*--|| UPDATES ||--*/
/*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    *//*    --||=||--    */
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/
/*--||========================================================================================================================================================================================================================||--*/

/*email*/
UPDATE users_ue AS ue SET email = '[new@user.email]'
  FROM (SELECT user_uid, username FROM users WHERE user_uid = [ACTIVE UUID]) AS u
  WHERE u.username = ue.username;

/*password*/
UPDATE users_ep AS ep SET password = '[new password]'
  FROM (SELECT user_uid, email FROM users JOIN users_ue USING (username) WHERE user_uid = [ACTIVE UUID]) AS ue
  WHERE ep.email = ue.email;

/*username*/
UPDATE users SET username = '[NEW USERNAME]'
  WHERE user_uid = [ACTIVE UUID];

/*first/last_name*/
UPDATE users SET first_name = '[NEW FIRST_NAME]'
  WHERE user_uid = [ACTIVE UUID];
UPDATE users SET last_name = '[NEW LAST_NAME]'
  WHERE user_uid = [ACTIVE UUID];

/*user_image_path*/
UPDATE users SET user_image_path = 'IMAGE/PATH/ON/SERVER/[NEW IMAGE]'
  WHERE user_uid = [ACTIVE UUID];

/*recipe updates :: ADMIN*/
UPDATE recipes SET [RECIPE ATTRIBUTE] = '[UPDATE VALUE]'
  WHERE [ACTIVE UUID] = '[ADMIN UUID]' AND recipe_id = [ACTIVE RECIPE PAGE ID];
/*OR IF THE UPDATORS IS THE OWNER OF THE RECIPE*/
UPDATE recipes SET [RECIPE ATTRIBUTE] = '[UPDATE VALUE]'
  WHERE recipe_id = [ASSOCIATED RECIPE PAGE ID] AND [ACTIVE UUID] = (SELECT user_uid FROM users JOIN users_recipes USING (username) WHERE recipe_id = [ASSOCIATED RECIPE PAGE ID]);

/*nutrition updates*/
UPDATE nutrition SET [NUTRITION ATTRIBUTE] = '[UPDATE VALUE]'
  WHERE [ACTIVE UUID] = '[ADMIN UUID]' AND recipe_id = [ACTIVE RECIPE PAGE ID];
/*OR IF THE UPDATORS IS THE OWNER OF THE RECIPE*/
UPDATE nutrition SET [NUTRITION ATTRIBUTE] = '[UPDATE VALUE]'
  WHERE recipe_id = [ASSOCIATED RECIPE PAGE ID] AND [ACTIVE UUID] = (SELECT user_uid FROM users JOIN users_recipes USING (username) WHERE recipe_id = [ASSOCIATED RECIPE PAGE ID]);








/*
:: EXPERIMENTAL QUERIES
INSERT INTO users(user_uid, first_name, last_name, username)
VALUES('531e7ce2-0731-4cfb-9bfa-6fd13a5ddad7', 'Ethan','Moon', 'afsas')
	ON CONFLICT (user_uid) DO UPSERT SET EXCLUDED.user_uid = uuid_generate_v4();

ON CONFLICT (user_uid) DO UPSERT SET EXCLUDED.user_uid = uuid_generate_v4();

SELECT * FROM recipes JOIN nutrition ON nutrition.nutrition_id = recipes.recipe_id;

SELECT * FROM recipes JOIN nutrition USING (recipe_id);

INSERT INTO users(..., user_image, ...) VALUES (..., pg_read_binary_file('[/PATH/]'), ...)

SELECT convert_from(user_image,'UTF8'); Look this up more

SELECT encode(user_image,'hex'); File carve to check headers and footers for format

INSERT INTO recipes(recipe_name, denomination) VALUES('Muscle Milk', 'snack');
*/
/*
with open(filename 'rb') as f:
	a = f.read
s.find(b'\xff\xc0')
*/

/*
SELECT * FROM (((users JOIN users_ue USING (username) AS u_i)
	LEFT JOIN (SELECT username, COUNT(*) AS recipes_created FROM users_recipes GROUP BY username) AS u_in USING (username)))
 	LEFT JOIN (SELECT user_uid, COUNT(*) AS recipes_favorited FROM users_favorites GROUP BY user_uid) AS u_inf USING (user_uid) AS user_info;
SELECT * FROM recipes
  WHERE recipe_id > 9000;
SELECT * FROM recipes JOIN (SELECT recipe_id FROM users_favorites
  WHERE user_uid = (SELECT user_uid FROM users WHERE username = 'FunnyReddit')) AS fav USING (recipe_id)
  ORDER BY recipe_id ASC LIMIT 30;
SELECT * FROM users_favorites
  WHERE user_uid = (SELECT user_uid FROM users WHERE username = 'FunnyReddit');
SELECT * FROM users_recipes
  WHERE username <> 'Operator';
SELECT * FROM users_favorites
  WHERE user_uid = (SELECT user_uid FROM users WHERE username = 'Operator');
SELECT * FROM users_recipes
  WHERE recipe_id > 9000;
*/
