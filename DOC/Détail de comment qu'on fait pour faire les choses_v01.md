Comment qu’on fait pour ramasser des trucs, etc. PRÉCISÉMENT !

J’avais oublié de l’ajouter mais il y est à présent dans la scène UI.tscn : on a une « icône » (Label) Inv. Pour ouvrir/fermer l’inventaire. Quand on clique dessus, l’inventaire s’ouvre ou se ferme (étonnant!). Il serait probablement judicieux que l’icône n’apparaisse que quand on survole l’emplacement de l’inventaire et disparaisse quand on s’en éloigne sauf quand il est ouvert.
	À tout moment, si Rowena se retrouve à transporter plus de 4 objets, elle refusera d’en prendre un nouveau en disant « Hey! I don't have four arms, I'm not Shiva! ».
	À noter également que lorsque dans l’inventaire, on dit « utiliser » A sur B, on peut tout à fait faire l’inverse !
	Toujours à noter : lorsque l’on fait bricoler des trucs à Rowena, elle le fera toujours de dos (elle a une animation pour ça) et il faudra prendre garde à ce qu’elle ne soit pas sur les bords de l’écran car il n’y a pas de plan sur lequel « bricoler ». Elle devra donc se déplacer si besoin.

1ère tentative : démonter la machine à café pour en lécher les restes de café dans les « tuyaux ».

	Pour récupérer le couteau à beurre il faut, 1) ouvrir le frigo (porte de droite) avec le curseur Hand (qui redevient Cross_Passive une fois fait), 2) si pas déjà fait, regarder une fois le beurre pour que Rowena dise « Butter. There's a little knife in it. » sinon elle refusera de le prendre en disant « Remember ? Coffee… »3) prendre le beurre (curseur Hand qui redevient Cross_Passive une fois fait). A ce moment-là, Rowena dira « Ok. I’ll take only that knife. » et elle aura alors le couteau à beurre dans son inventaire. RAPPEL pour la suite : tout autre couteau ne fera pas l’affaire !
	Pour ouvrir le support à filtre à café de la cafetière sur le plan de travail en considérant que Rowena a déjà le couteau à beurre, il faut 1) que Rowena ait déjà regardé la cafetière et qu’elle ait dit « It's empty. I could cry if I had time. The filter holder is stuck.» sinon, si elle a le couteau à beurre, elle dira « That’s not my sparing partner. » et si elle ne l’a pas elle dira « Ok… Actually, no ! », 2) que Rowena clique sur le couteau à beurre dans son inventaire avec le curseur Hand qui se transformera en Arrow puis 3) ferme l’inventaire et 4) clique sur la cafetière redonnant la forme Cross_Passive au curseur (si elle est trop loin, alors elle marchera jusqu’à la cafetière (son collider sert à ça, pour qu’elle s’arrête à portée). A ce moment-là, elle se retournera et dira « Yes, I can remove it without breaking anything. » et le porte-filtre sera dans son inventaire.
	Rowena ira 1) chercher le petit torchon (curseur Hand) à gauche de la fenêtre de droite contre le mur (le curseur reprendra la forme Cross_Passive). 2) Ouvrira l’inventaire, 3) Avec le curseur Hand prendra le petit torchon dans son inventaire (le curseur passera alors à Arrow) et 4) cliquera sur le porte-filtre (le curseur redeviendra Cross_Passive). Elle se retournera et dira « It works, but I can't get enough coffee out of it. ». Ça ne marche donc pas !
	Elle devra alors humidifier le torchon avec le lait du frigo avant de « curer » le porte-filtre. Pour cela, elle devra 1) ouvrir la porte de droite du réfrigérateur pour y prendre (curseur Hand) la bouteille de lait qui se retrouvera dans son inventaire. 2) dans son inventaire, prendre (curseur Hand) le torchon (le curseur devient Arrow), 3) cliquer sur la bouteille de lait. A ce moment-là, Rowena se retrouvera avec un torchon imbibé de lait (Milk-soaked towel) dans son inventaire.
	Pour finir, 1) elle prendra (curseur Hand) le torchon imbibé de lait (le curseur redevient Arrow) pour 2) l’utiliser sur le porte-filtre. À ce moment Rowena se retournera et dira « It should be more absorbent now. » puis « Let’s taste it ! » et se retournera à nouveau (donc de dos), jouera une fois son animation de Do_Erk_Stuff en disant « Erk! » (il est possible que je supprime le son de l’anim Do_Erk_Stuff). Ça fera bien trop peu (en plus du fait que ça n’est pas bon du tout) !

	Une fois fait, on enchaîne sur le deuxième dialogue.


2ème tentative : récupérer des vieux grains de café tombés derrière les pots et le meuble pour les moudre et obtenir une poudre afin de s’en faire des patchs.
	/!\ Je ne vais pas répéter à nouveau les moindres détails logiques qui ont déjà été présentées au dessus, je pense qu’on a compris.

	Récupérer des grains de café :
	Sur le plan de travail, à côté du pot en terre, derrière le sel qu’il faut enlever pour les trouver, Rowena pourra trouver quelques grains de cafés perdus. Ça n’est pas suffisant, il faut ceux mentionnés juste en dessous.
	Par terre, entre le lave-vaisselle et le meuble à sa droite, Rowena trouvera encore des grains de café.
	/!\  Ces grains de café ne seront pas trouvables lors de la première tentative !
	L’ordre pour trouver ces grains de café n’a pas d’importance.
	Tant que Rowena n’aura  ramassé qu’une dose de grains de café, dans son inventaire elle n’aura que : « Not enough coffee beans ».
	Lorsque Rowena aura ramassé les deux doses de grains de café, elle n’aura plus que : « Enough coffee beans » dans son inventaire. Soit les deux doses cumulées.

	Moudre les vieux grains de café (elle n’a pas de moulin à café) :
	Rowena trouvera une cuillère en bois dans le tiroir du haut du meuble à droite de la gazinière.
	Elle réutilisera son torchon (l’autre, le grand, est trop « dégueu »).
	/!\ Pour les étapes suivantes, à chaque fois, après avoir dit « Ok. Well, that's something. », « Looks like a plan to me ! » et « Last step ! », elle jouera son animation Turn_Back puis Do_Stuff puis Turn_Front.
	Elle placera les grains de café dans le torchon et les écrasera avec la cuillère en bois. Il faut utiliser les éléments dans un ordre précis.
	Utiliser le torchon sur les grains de café (Rowena dira « Ok. Well, that's something. ») pour avoir dans l’inventaire « Towel with coffee beans », puis utiliser la cuillère en bois dessus pour que Rowena dise « Looks like a plan to me ! » pour avoir dans son inventaire « Small towel » et « Ground coffee beans ». Une fois fait, Rowena dira alors « One small step for man, one giant leap… ».

	Se faire un patch au café :
	Encore une fois, ici aussi, à chaque fois que Rowena assemble des trucs, elle joue ses animation Turn_Back, Do_Stuff puis Turn_Front !
	Il reste des filtres à café dans le tiroir du milieu à gauche de la gazinière. Elle en prendra un pour avoir un « Coffee filter » dans son inventaire.
	Dans le tiroir de droite dans lequel il y a les couverts, elle prendra un couteau.
	Elle dira « Alright ! » avant d’utiliser le filtre à café sur la planche à découper.
	Ensuite elle dira « Okay, but just this once. » avant d’utiliser le couteau sur la planche à découper avec un filtre à café obtenant  « Cutting board d’un côté » et « Half Coffee filter » de l’autre.
	Elle prendra le rouleau de scotch dans le Top_Left_Drawer. Pour couper un morceau de scotch, soit elle utilisera le scotch sur lui-même, soit elle utilisera le couteau dessus. Elle obtiendra en plus un « Piece of tape ».
	Elle dira « Clever me ! » et mettra son café moulu dans le demi filtre à café pour obtenir Ground coffee in half a filter (cela peut être fait avant d’aller récupérer le scotch) et le fermera avec un morceau de scotch qu’elle aura coupé du rouleau. Elle dira « Ok, it’s now sealed. » avant d’obtenir a « Coffee Patch ».
	Puis coupera à nouveau un morceau de scotch. Et l’utilisera sur le patch au café.
	/!\ IL FAUT QUE JE FASSE UNE ANIMATION POUR QUE ROWENA APPLIQUE LE PATCH SUR SON BRAS ! /!\
	Elle décidera que ça ne marche pas au bout de 5 secondes (pendant ces 5 secondes, le joueur ne pourra plus intervenir). Sans doute car il est trop sec. Elle dira « Darn! This thing does nothing ! » et enlèvera le patch (on rejoue l’animation d’application du patch dans le son si j’en ai mis un).
	Rowena dira « Yeah, that should make it porous... » et ira humidifier (utiliser) son patch sous le robinet de l’évier (je dois voir si je peux trouver un son de robinet qui coule).
	Replacera (animation!) son patch sur son bras (le scotch fonctionnera encore).
	Elle attendra à nouveau 5 secondes, dira « Damn it, it doesn't work at all! » : ça ne marche définitivement pas.
		
	Une fois fait, on enchaîne sur le troisième dialogue.