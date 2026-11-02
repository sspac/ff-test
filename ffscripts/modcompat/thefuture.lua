local mod = FiendFolio

--Post mod load thing
mod.scheduleForUpdate(function()
	if TheFuture then
        TheFuture.ModdedTaintedCharacterDialogue["Golem"]  = {
			"see what i mean people",
			"the price for missing these tinted rocks",
			"its getting too friggin high!",
			"this tinted rock has grown appendages!",
			"dont blow me up, alright?"
		}
		TheFuture.ModdedCharacterDialogue["Friend"] = {
			"alright cool youre packing heat",
			"dont flaunt that around keep it lowkey",
			"i want someone gone",
			"theyre solid black, missing an eye, tumory",
			"kill him, you get all his stuff. good luck"
		}
		TheFuture.ModdedTaintedCharacterDialogue["Friend"] = {
			"where the hell are these hats coming from?",
			"...",
			"i want one...",
			"a gun?",
			"do you see any hands on me buddy?",
			"what am i gonna do with a gun?"
		}
        TheFuture.ModdedCharacterDialogue["Inaba"] = {
            "you look like youve got a killer headache",
            "need some painkillers or something?",
            "oh its a full on migraine, ouch",
            "sit down and rest a while in here"
        }
        TheFuture.ModdedTaintedCharacterDialogue["Inaba"]  = {
            "welcome to a fork in the road",
            "where do you want to go?",
            "it doesnt matter",
            "it all leads to the future"
        }
        TheFuture.ModdedCharacterDialogue["Craig"]  = {
			"i felt that, when you got close",
			"the most miniscule static shock",
			"...",
			"sorry, im lying",
			"i dont feel anything anymore"
        }
        TheFuture.ModdedCharacterDialogue["Classic Fiend"]  = {
			"must be strange",
			"someone from the past",
			"ending up in the present",
			"want to try out the future?"
        }
        TheFuture.ModdedCharacterDialogue["Image"]  = {
			"i feel like anything i could say",
			"would go in one ear and out the other",
			"i bet youre not even paying attention right now",
			"...",
			"just go in already"
        }
        TheFuture.ModdedCharacterDialogue["The Skeletal Fiend"]  = {
			"you're pretty bad to the bone if-",
			"uh",
			"it's humerus that-",
			"...",
			"hmm, i should really-",
			"nevermind"
        }
        TheFuture.ModdedCharacterDialogue["Frond"]  = {
			"dude, your fronds stink",
			"can you wipe them before coming in",
			"otherwise ill taste you until last thursday"
        }
        TheFuture.ModdedCharacterDialogue["Mi"]  = {
			"if you think about it",
			"the future is like a copy of the present",
			"each second, a copy more and more different",
			"youre the most future of all of us"
        }
        TheFuture.ModdedCharacterDialogue["Freezer Jr."]  = {
			"hey man, last time someone crashed out",
			"took me a week to clean up the place",
			"promise you wont make a mess?"
        }
	end
end, 1, ModCallbacks.MC_POST_RENDER, true)