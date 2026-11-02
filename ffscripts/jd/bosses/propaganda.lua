local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local music = MusicManager()

local font = Font()
font:Load("font/upheaval.fnt")

local PaperSprite = Sprite()
PaperSprite:Load("gfx/bosses/propaganda/effect_propagandaslide.anm2", true)
PaperSprite:Play("Exit")

local PaperSprite2 = Sprite()
PaperSprite2:Load("gfx/bosses/propaganda/effect_propagandaslide.anm2", true)
PaperSprite2:Play("Exit")
PaperSprite2:GetLayer(0):SetCropOffset(Vector(48,0)) --Front hand
PaperSprite2:GetLayer(1):SetCropOffset(Vector(48,0)) --Back hand
PaperSprite2:GetLayer(2):SetCropOffset(Vector(112,0)) --Paper

local RenderPapers = false

local PromptSprite = Sprite()
PromptSprite:Load("gfx/bosses/propaganda/ui_buttonprompt.anm2", true)
--print(PromptSprite:GetLayer(0):GetCropOffset())
local inputs = {ButtonAction.ACTION_SHOOTLEFT, ButtonAction.ACTION_SHOOTUP, ButtonAction.ACTION_SHOOTRIGHT, ButtonAction.ACTION_SHOOTDOWN}

local PortraitSprite = Sprite()
PortraitSprite:Load("gfx/bosses/propaganda/player_portrait.anm2", true)
local NameSprite = Sprite()
NameSprite:Load("gfx/bosses/propaganda/player_name.anm2", true)

local inPhase2 = false --used for death sound

local PropagandaWords = { --Word, then weight   5 LETTERS MAX
	{"LIES", 1},
	{"TRUTH", 1},
	{"RIGHT", 1},
	{"WRONG", 1},
	{"PEACE", 1},
	{"WAR", 1},
	{"WRATH", 1},
	{"GLORY", 1},
	{"SEE", 1},
	{"SPEAK", 1},
	{"HEAR", 1},
	{"LOVE", 1},
	{"HATE", 1},
	{"LIFE", 1},
	{"DEATH", 1},
	{"THINK", 1},
	{"FEEL", 1},
	{"OBEY", 1},
	{"BLOOD", 1},
	{"FIGHT", 1},
	{"BLAH", 1},
	{"!!!", 1},
	{"GOOD", 1},
	{"EVIL", 1},
	{"POWER", 1},
	{"MONEY", 1},
	{"FAME", 1},
	{"#%!@", 1},
	{"BURN", 1},
	{"FUEL", 1},
	{"FLESH", 1},
	{"BONE", 1},
	{"MIND", 1},
	{"WORK", 1},
	{"SLEEP", 1},
	{"FUN", 1},
	{"GAMES", 1},
	{"START", 1},
	{"STOP", 1},
	{"TOXIC", 1},
	{"CEASE", 1},
	{"JOY", 1},
	{"LAUGH", 1},
	{"PAIN", 1},
	{"TRUST", 1},
	{"HURT", 1},
	{"NOISE", 1},
	{"QUIET", 1},
	{"SHOOT", 1},
	{"HEART", 0.5},
	{"SOUL", 0.5},
	{"DEVIL", 0.5},
	{"ANGEL", 0.5},
	{"LIKE", 0.5},
	{"SHARE", 0.5},
	{"HAHA", 0.25},
	{"LOL", 0.25},
	{"LMAO", 0.25},
	{"XD", 0.25},
	{"COPE", 0.25},
	{"SORRY", 0.25},
	{"NARC",0.25},
	{"MACHI", 0.25},
	{"PSYCH", 0.25},
	{"1984", 0.05},
	{"ISAAC", 0.05},
	{"BISS", 0.05},
	{"POOP", 0.05},
	{"PEAT", 0.01},
	{"SLAY", 0.01},
}

local PropagandaFortunes = {
	{{"IT'S SPELLED PROPOGANDA"}, 1},
	{{"STAND STILL TO WIN"}, 1},
	{{"QUALITY 5 BOSS"}, 1},
	{{"SHUT UP!!!!"}, 1},
	{{"BREAK THE CYCLE"}, 1},
	{{"EYE FOR AN EYE"}, 1},
	{{"JOIN OR DIE"}, 1},
	{{"HOW TERRIBLE"}, 1},
	{{"ITEMS ARE FOR BABIES"}, 1},
	{{"THE HORSE GIVES KISSES"}, 1},
	{{"NERF BRIMSTONE"}, 1},
	{{"YOU ARE NOT IMMUNE"}, 1},
	{{"JUST GIVE UP"}, 1},
	{{"TRY MASHING BUTTONS"}, 1},
	{{"PRESS ESC FOR HELP"}, 1},
	{{"THIS FORTUNE IS TRUE"}, 1},
	{{"THIS FORTUNE IS A LIE"}, 1},
	{{"I WILL GET YOU"}, 1},
	{{"CEASE TO EXIST"}, 1},
	{{"SHUT UP AND SIT DOWN"}, 1},
	{{"FOLLOW YOUR LEADER"}, 1},
	{{"KNOW YOUR PLACE"}, 1},
	{{"I AM IN YOUR WALLS"}, 1},
	{{"GET OUT OF TOWN"}, 1},
	{{"CRY ABOUT IT"}, 1},
	{{"TAKE A SHOWER"}, 1},
	{{"YOU STINK"}, 1},
	{{"BUY GOLD"}, 1},
	{{"GAMBLE MORE"}, 1},
	{{"I'M THE BEST HORSEMAN"}, 1},
	{{"NEVER STOP RAMBLING"}, 1},
	{{"HIDDEN LORE INCOMING"}, 1},
	{{"IT'S ALL YOUR FAULT"}, 1},
	{{"YOU KNOW NOTHING"}, 1},
	{{"OPEN THE SCHOOLS"}, 1},
	{{"THE COUNCIL", "IS WATCHING"}, 1},
	{{"YOU'LL BE MY", "NEXT HEADLINE"}, 1},
	{{"I COULD BEAT YOU", "WITH MY EYES CLOSED"}, 1},
	{{"STOP CRYING", "YOU'RE GETTING SNOT", "EVERYWHERE"}, 1},
	{{"THIS RUN", "IS A TRAGEDY"}, 1},
	{{"TUNE IN TO", "YOUR DOOM"}, 1},
	{{"YOU WIN THE", "CRYING CONTEST"}, 1},
	{{"WELCOME YOUR", "NEW OVERLORD"}, 1},
	{{"GO TO BED", "IT'S A SCHOOL NIGHT"}, 1},
	{{"TAKE YOUR", "BEST SHOT"}, 1},
	{{"SOMETHING THAT", "MAKES YOU MAD"}, 1},
	{{"YOU'VE HAD IT GOOD", "FOR TOO LONG"}, 1},
	{{"GO BACK TO", "THE BASEMENT"}, 1},
	{{"SOME WORDS CAN", "HEAL YOU"}, 1},
	{{"WALK BEHIND THE", "PURPLE FORTUNES"}, 1},
	{{"THE PURPLE FORTUNES", "TASTE FUNNY"}, 1},
	{{"YOU DO NOT HAVE", "EXECUTIVE AUTHORITY"}, 1},
	{{"THERE ARE PEOPLE", "IN THIS WORLD"}, 1},
	{{"YOU WOULDN'T LIKE ME", "WHEN IM ANGRY"}, 1},
	{{"THEY'LL NEVER SEE", "IT COMING"}, 1},
	{{"NEVER DO ANYTHING", "FOR FREE"}, 1},
	{{"THREE HEADS ARE", "BETTER THAN ONE"}, 1},
	{{"THERE IS SOMETHING", "ON YOUR FACE"}, 1},
	{{"YOU'LL PAY FOR", "MY FACES"}, 1},
	{{"WHAT ARE YOU DOING", "RIGHT NOW"}, 1},
	{{"TODAY IS YOUR", "LUCKY DAY"}, 1},
	{{"TAKE OFF YOUR SKIN", "AND LIVE A LITTLE"}, 1},
	{{"IDIOTS LIKE YOU", "MAKE THE WORLD GO ROUND"}, 1},
	{{"TOXIC WASTE", "GIVES YOU POWERS"}, 1},
	{{"I WILL PARADE", "OVER YOUR CORPSE"}, 1},
	{{"NOT LIKE IT", "USED TO BE"}, 1},
	{{"KEEP AN EAR", "TO THE FLOOR"}, 1},
	{{"ARE YOU EVEN", "LISTENING"}, 1},
	{{"WALK IN A CIRCLE", "AND QUACK", "LIKE A DUCK"}, 1},
	{{"KEEP READING", "YOU HAVE NOTHING", "BETTER TO DO"}, 1},
	{{"DON'T JUST STAND THERE", "DANCE", "DANCE FOR ME"}, 1},
	{{"I BET THIS IS", "MAKING IT HARDER", "TO DODGE"}, 1},
	{{"THIS FORTUNE", "COVERS UP", "A LOT OF SPACE!"}, 1},
	{{"THANK YOU", "YOU'VE BEEN A", "GREAT AUDIENCE"}, 1},
	{{"IF YOU READ THIS", "YOU HAVE", "ALREADY LOST!"}, 1},
	{{"I'M NOT IN THE WAY", "YOUR SCREEN IS JUST", "TOO SMALL"}, 1},
	{{"YOU'RE A", "DEAD BABY WALKING"}, 1},
	{{"YOU BETTER QUIT", "BEFORE I SAY", "SOMETHING MEAN"}, 1},
	{{"FIGHT SOMEONE", "YOUR OWN SIZE", "LIKE BABIES"}, 1},
	{{"WATCH YOUR BACK", "THE NEXT TIME", "YOU HEAD OUTSIDE"}, 1},
	{{"THIS IS NOT", "A FORTUNE"}, 1},
	{{"FINANCIAL OPPORTUNITY", "LIES AHEAD"}, 0.5},
	{{"YOU DON'T KNOW HOW MUCH", "THIS IS COSTING ME"}, 0.5},
	{{"TODAY'S", "LUCKY NUMBERS", "12 15 19 71"}, 0.5},
	{{"LUCK WILL VISIT", "YOU ON THE NEXT", "BLOOD MOON"}, 0.5},
	{{"ITS YOUR FAULT", "WE'RE RUNNING LOW", "ON PAPER"}, 0.5},
	{{"I HOPE", "YOU LIKED", "YOUR PORTRAIT"}, 0.5},
	{{"BIG BROTHER IS WATCHING"}, 0.5},
	{{"AND BEST OF ALL", "FLYING HEADS"}, 0.5},
	{{"CHUB LOVES SMOKE"}, 0.5},
	{{"DOOMED TO DEATH", "OF KARMA!"}, 0.5},
	{{"THE CHILD LEFT BEHIND"}, 0.5},
	{{"LOOK INTO THE SUN"}, 0.5},
	{{"GO PLAY ARTS AND", "CRAFTS WITH DAD"}, 0.25},
	{{"THREE FACED TERROR", "MURKS NAKED CHILD", "IN WOMB"}, 0.25},
	{{"THREE FACED HUNK", "REVEALS MASSIVE", "BRAIN"}, 0.25},
	{{"MATRIARCH HATES SMOKE"}, 0.25},
	{{"IT'S SPELLED PROPAGONDA"}, 0.1},
	{{"IT'S SPELLED PROPAGANADA"}, 0.1},
	{{"IT'S SPELLED PROPOGONDO"}, 0.1},
	{{"STOP PLAYING WITH MODS"}, 0.1},
	{{"A CORPSE IS TALKING"}, 0.1},
	{{"YOU WILL NOT", "GET MERN"}, 0.1},
	{{"DO NOT PLAY", "FIEND FOLIO"}, 0.1},
	{{"I COULDN'T", "THINK OF SOMETHING"}, 0.1},
	{{"PRESS ALT + F4 FOR HELP"}, 0.1},
	{{"IT'S STAGE API'S FAULT"}, 0.1},
	{{"IT'S REPENTOGON'S FAULT"}, 0.1},
	{{"IT'S SPELLED PROPAGOONDA"}, 0.025},
	{{"JD WAS HERE"}, 0.025},
	{{"YOU LOVE", "FIEND", "DON'T YOU?"}, 0.1},
}
local function loadDevFortune(_, isContinue)
	PropagandaFortunes[#PropagandaFortunes] = {{"YOU LOVE", FiendFolio.Developers[FiendFolio.DataHarvesting.Dev], "DON'T YOU?"}, 0.1}
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, loadDevFortune)

local PropagandaSpawns = {
	{{EntityType.ENTITY_LEPER, 1, 0}, 1}, --Leper Flesh
	{{EntityType.ENTITY_GLOBIN, 0, 0}, 1}, --Globin
	{{EntityType.ENTITY_FACELESS, 0, 0}, 1}, --Faceless
	{{EntityType.ENTITY_GUTS, 1, 0}, 1}, --Scarred Guts
	{{EntityType.ENTITY_VIS, 2, 0}, 1}, --Chubber
	{{EntityType.ENTITY_PARA_BITE, 1, 0}, 1}, --Scarred Para-Bite
	{{EntityType.ENTITY_CHARGER, 0, 0}, 1}, --Charger
	{{EntityType.ENTITY_FISTULOID, 0, 0}, 0.5}, --Fistuloid
	{{EntityType.ENTITY_BRAIN, 0, 0}, 0.5}, --Brain
	{{EntityType.ENTITY_BABY, 0, 0}, 0.5}, --Baby
	{{EntityType.ENTITY_MAW, 1, 0}, 0.5}, --Red Maw
	{{EntityType.ENTITY_BOOMFLY, 1, 0}, 0.5}, --Red Boom Fly
	{{EntityType.ENTITY_NERVE_ENDING, 0, 0}, 0.01}, --Nerve Ending (rare funny)
	{{EntityType.ENTITY_NERVE_ENDING, 1, 0}, 0.0025}, --Nerve Ending 2 (rarer funny)

	--FF enemies
	{{FiendFolio.FF.Contestant.ID, FiendFolio.FF.Contestant.Var, FiendFolio.FF.Contestant.Sub}, 1}, --Contestant (no nail)
	{{FiendFolio.FF.Contestant.ID, FiendFolio.FF.Contestant.Var, 1}, 1}, --Contestant (with nail)
	{{FiendFolio.FF.Myiasis.ID, FiendFolio.FF.Myiasis.Var, 0}, 1}, --Myiasis
	{{FiendFolio.FF.Myiasis.ID, FiendFolio.FF.Myiasis.Var, 1}, 1}, --Myiasis (empty)
	{{FiendFolio.FF.RedBony.ID, FiendFolio.FF.RedBony.Var, FiendFolio.FF.RedBony.Sub}, 1}, --Red Bony

	{{FiendFolio.FF.Gleek.ID, FiendFolio.FF.Gleek.Var, FiendFolio.FF.Gleek.Sub}, 0.5}, --Gleek
	{{FiendFolio.FF.CurdleNaked.ID, FiendFolio.FF.CurdleNaked.Var, FiendFolio.FF.CurdleNaked.Sub}, 0.5}, --Naked Curdle
	--{{FiendFolio.FF.Curdle.ID, FiendFolio.FF.Curdle.Var, FiendFolio.FF.Curdle.Sub}, 0.5}, --Curdle
	{{FiendFolio.FF.Facade.ID, FiendFolio.FF.Facade.Var, FiendFolio.FF.Facade.Sub}, 0.5}, --Facade
	--{{FiendFolio.FF.Lipoma.ID, FiendFolio.FF.Lipoma.Var, FiendFolio.FF.Lipoma.Sub}, 0.5}, --Lipoma
	{{FiendFolio.FF.Vacuole.ID, FiendFolio.FF.Vacuole.Var, FiendFolio.FF.Vacuole.Sub}, 0.5}, --Vacuole
	--{{FiendFolio.FF.Incisor.ID, FiendFolio.FF.Incisor.Var, FiendFolio.FF.Incisor.Sub}, 0.5}, --Incisor
}

local bal = { --Thanks Ferrium! I stoled a bunch of this stuff
    Speed = 2.5,
    Speed2 = 2.5,
    Speed3 = 0.66,
    HorseOffset = Vector(50, 10),

    MRange = 180, --Range for random movement
    MMax = 20, --Max time moving
    MRest = {30,60}, --Random wander period
    MRestChance = 2, --Chance to wander after moving
    MWChance = 5, --This and below are stuff that determines random wandering
    MWTime = 30,
    MFNum = 4, --Moves toward the player every X move triggers
}

local function SlopeFunc(m, x, y) --only input the one needed, return where x/y would be in the equation
    local cent = game:GetRoom():GetCenterPos()
    local b = cent.Y-m*cent.X
    if x then
        return m*x+b
    else
        return (y-b)/m
    end
end

local function NearestDirection(angle)
    -- Normalize the angle to be between 0 and 360 degrees
    angle = angle % 360

    -- Define the compass directions and their corresponding angle ranges
    local directions = {
        { name = "N", min = 337.5, max = 360 },
        { name = "N", min = 0, max = 22.5 },
        { name = "NE", min = 22.5, max = 67.5 },
        { name = "E", min = 67.5, max = 112.5 },
        { name = "SE", min = 112.5, max = 157.5 },
        { name = "S", min = 157.5, max = 202.5 },
        { name = "SW", min = 202.5, max = 247.5 },
        { name = "W", min = 247.5, max = 292.5 },
        { name = "NW", min = 292.5, max = 337.5 }
    }

    -- Find and return the nearest direction
    for _, direction in ipairs(directions) do
        if angle >= direction.min and angle < direction.max then
            return direction.name
        end
    end

    -- Fallback in case angle doesn't match any range (should not happen)
    return "N"
end


local function CheckLine(pos, dir, str)
    local room = game:GetRoom()
    local check = true
    local failsafe = 0
    local origin = pos
    while check or failsafe < 15 do
        failsafe = failsafe+1
        local checkPos = pos+dir*failsafe
        origin = pos-dir
        if room:GetGridCollisionAtPos(checkPos) >= GridCollisionClass.COLLISION_OBJECT then
            return {origin, 40*failsafe, dir, str}
        end
    end
    return {origin, failsafe*40, dir, str}
end

local function KColorLerp(kcolor1, kcolor2, amount)
	return KColor(mod:Lerp(kcolor1.Red, kcolor2.Red, amount), mod:Lerp(kcolor1.Green, kcolor2.Green, amount), mod:Lerp(kcolor1.Blue, kcolor2.Blue, amount), mod:Lerp(kcolor1.Alpha, kcolor2.Alpha, amount))
end

local function GetPropagandaAttack(d, rng, attacks)
    if d.LastPropagandaAttack then
        local list = mod:RemoveEntryThroughResult(attacks, d.LastDelugeAttack)
        local first = list[rng:RandomInt(#list)+1]
        local attacks2 = mod:RemoveEntryThroughResult(attacks, first)
        local ret = mod:GetRandomOrderedTable(attacks2, rng, {first})
        d.LastPropagandaAttack = ret[3]
        return ret
    else
        local ret = mod:GetRandomOrderedTable(attacks, rng)
        d.LastPropagandaAttack = ret[3]
        return ret
    end
end

local numToDir = {[1] = "R", [2] = "DR", [3] = "D", [4] = "DL", [5] = "L", [6] = "UL", [7] = "U", [8] = "UR"}

function mod:PropagandaAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    local room = game:GetRoom()
    local rng = npc:GetDropRNG()
    local targetPos = mod:confusePos(npc, target.Position)
	local facingVec = 1

	if npc.FlipX then
		facingVec = -1
	end

	if npc:IsDead() then
		sfx:Play(mod.Sounds.PropagandaDeath, 1)
		sfx:Stop(mod.Sounds.PropagandaAmbient)
	end

	inPhase2 = d.Phase == 1

    if not d.Init then
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        d.LastPropagandaDir = "L"
        d.State = "Idle"
		d.FaceState = "Idle"
		d.AttackTimer = 130
		d.FaceTimer = 100
		d.Phase = 0
		d.FaceAngle = 0
		d.PropagandaFaces = {}
		d.AttackTable = mod:ShuffleTable({1,2,3})
		RenderPapers = false

        d.Init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.State == "Idle" then
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        if d.PreparedForPhaseChange then
            d.State = "ChangingPhases"
        else

			if mod:isScare(npc) then
				npc.Velocity = mod:Lerp(npc.Velocity, (targetPos-npc.Position):Resized(bal.Speed*1.5), 0.3)
			else
				if not d.MoveDest then
					d.MoveFrames = 0
					d.MoveDest = mod:FindRandomValidPathPosition(npc, 3, 60, bal.MRange)
					d.MoveNums = 0
					d.WanderVec = Vector(0, bal.Speed2):Rotated(rng:RandomInt(360))
				end

				d.MoveFrames = d.MoveFrames+1

				if d.MoveRest then
					if d.MoveRest > 0 then
						npc.Velocity = mod:Lerp(npc.Velocity, d.WanderVec:Resized(bal.Speed2), 0.15)
						d.MoveRest = d.MoveRest-1
						d.WanderTime = (d.WanderTime or 0)+1
						if npc:CollidesWithGrid() then
							d.WanderTime = d.WanderTime+1
						end
						if d.WanderTime > bal.MWTime and rng:RandomInt(bal.MWChance) == 0 then
							d.WanderTime = 0
							d.WanderVec = Vector(0, bal.Speed2):Rotated(rng:RandomInt(360))
						end
					else
						d.MoveFrames = 0
						d.MoveDest = mod:FindRandomValidPathPosition(npc, 3, 60, bal.MRange)
						d.MoveRest = nil
					end
				elseif npc.Position:Distance(d.MoveDest) < 20 or d.MoveFrames > bal.MMax then
					d.MoveNums = (d.MoveNums or 0)+1
					if rng:RandomInt(bal.MRestChance) == 0 then
						d.MoveRest = mod:RandomInt(bal.MRest[1], bal.MRest[2], rng)
					elseif d.MoveNums > bal.MFNum then
						d.MoveNums = 0
						d.MoveFrames = 0
						d.MoveDest = mod:FindClosestValidPosition(npc, target, 60, bal.MRange, 0)
					else
						d.MoveFrames = 0
						d.MoveDest = mod:FindRandomValidPathPosition(npc, 3, 60, bal.MRange)
					end
				else
					if room:CheckLine(npc.Position, d.MoveDest, 3, 1, false, false) then
						local targetvel = (d.MoveDest - npc.Position):Resized(bal.Speed)
						npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.25)
					elseif npc.Pathfinder:HasPathToPos(d.MoveDest) then
						npc.Pathfinder:FindGridPath(d.MoveDest, bal.Speed/6.5, 900, true)
					else
						d.MoveRest = mod:RandomInt(bal.MRest[1], bal.MRest[2], rng)
					end
				end
			end

			if sprite:GetAnimation() ~= "Transition" then
				if d.Phase == 0 then
					mod:spritePlay(sprite, "Idle")
					sprite.FlipX = d.WanderVec.X < 0

					if npc.HitPoints <= npc.MaxHitPoints/2 then
						sprite:Play("PhaseTrans")
						d.State = "PhaseTrans"
						d.Phase = 1
						d.AttackTimer = mod:RandomInt(350, 450)
						npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
						npc.FlipX = false
					elseif not mod:isScareOrConfuse(npc) then
						d.AttackTimer = math.max(d.AttackTimer-1, 0)
						if d.AttackTimer == 0 then
							sprite:Play("Transition")
							d.AttackTimer = mod:RandomInt(80, 120)
							if npc.Position.X > target.Position.X then
								npc.FlipX = true
							else
								npc.FlipX = false
							end
						end
					end
				else
					if sprite:IsFinished() then
						mod:spritePlay(sprite, "BrainIdle")
					end
					--npc:PlaySound(mod.Sounds.PropagandaStatic, 5)
					d.FaceAngle = d.FaceAngle + 1
					d.FaceTimer = math.max(d.FaceTimer-1, 0)
					if npc.FrameCount % 20 == 0 then
						local splat = Isaac.Spawn(1000, 7, 0, npc.Position, Vector.Zero, npc)
						splat.Color.A = 0.4
					end
					if npc.FrameCount % 60 == 0 and not npc:IsDead() then
						local vol = 0.5 + ((1.0 - (npc.HitPoints / (npc.MaxHitPoints / 2))) * 1.5)
						npc:PlaySound(mod.Sounds.PropagandaAmbient, vol)
					end
					--print(d.AttackTimer)
					if d.AttackTimer == 0 and not d.PropagandaSpotlight and sprite:GetFrame() == 0 then
						sprite:Play("BrainSpotlight")
						sfx:Play(mod.Sounds.PropagandaDrumroll)
						d.PropagandaPrompts = {}
						for i = 1, 10 do
							table.insert(d.PropagandaPrompts, mod:RandomInt(Direction.LEFT, Direction.DOWN))
						end
						d.SpotlightFrame = 0
						d.PromptBlunder = false
						d.PromptWin = false
						d.SpotlightFail = false
						--[[print(Isaac.CountEnemies()-5)
						if d.FaceState == "Idle" and (Isaac.CountEnemies()-5) <= 0 then
							d.FaceTimer = 0
						end]]

						d.AttackTimer = mod:RandomInt(80, 120)
					end
					if d.PropagandaSpotlight then
						game:Darken(0.9, 5)
						music:VolumeSlide(0.5, 0.05)

						if not sfx:IsPlaying(mod.Sounds.PropagandaDrumroll) and not sfx:IsPlaying(mod.Sounds.PropagandaDrumrollLoop) then
							sfx:Play(mod.Sounds.PropagandaDrumrollLoop, 1, 0, true)
						end

						if npc:IsDead() then
							d.PropagandaPrompts = {}
							sfx:Play(mod.Sounds.PropagandaCymbal)
							sfx:Stop(mod.Sounds.PropagandaDrumrollLoop)
						end
						--[[if d.AttackTimer == 0 and sprite:GetFrame() == 0 then
							sprite:Play("BrainFire")
							sfx:Play(SoundEffect.SOUND_GHOST_SHOOT)
							d.AttackTimer = mod:RandomInt(60, 100)
						end]]

						d.SpotlightFrame = d.SpotlightFrame + 1

						if #d.PropagandaPrompts == 0 and d.PropagandaSpotlight:GetSprite():GetAnimation() == "Appear" then
							d.PropagandaSpotlight:GetSprite():Play("Disappear")
							sprite:Play("BrainMad")
						end
						if d.PropagandaSpotlight.FrameCount > 170 then
							d.PropagandaSpotlight.Color = Color.Lerp(Color.Default, Color(1, 0.5, 0.5, 2, 0, 0, 0), math.min(50, d.PropagandaSpotlight.FrameCount-170)/50)
						end
						if d.PropagandaSpotlight.FrameCount > 220 and d.PropagandaSpotlight:GetSprite():GetAnimation() == "Appear" then
							d.PropagandaSpotlight:GetSprite():Play("Disappear")
							sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
							sfx:Play(SoundEffect.SOUND_LIGHTBOLT)
							d.SpotlightTarget:TakeDamage(2, 0, EntityRef(npc), 0)
							d.SpotlightFail = true
							sprite:Play("BrainLaugh")
						end
						if d.PropagandaSpotlight:GetSprite():GetAnimation() == "Disappear" and d.PropagandaSpotlight:GetSprite():IsFinished() then
							d.PropagandaSpotlight:Remove()
							d.PropagandaSpotlight = nil
							d.AttackTimer = mod:RandomInt(500, 700)
							sfx:Play(mod.Sounds.PropagandaCymbal)
							sfx:Stop(mod.Sounds.PropagandaDrumrollLoop)
						end
					else
						music:VolumeSlide(1, 0.1)
					end
					d.AttackTimer = math.max(d.AttackTimer-1, 0)

					if sprite:IsEventTriggered("Shoot") then
						if sprite:GetAnimation() == "BrainFire" then
							local vel = Vector(12, 0):Rotated((target.Position-npc.Position):GetAngleDegrees())
							local chunk = Isaac.Spawn(EntityType.ENTITY_LEPER, 1, 0, npc.Position, vel, npc):ToNPC()

							chunk:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
							mod:GetEntityData(chunk).PropagandaVel = vel
							chunk.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

							Isaac.Spawn(1000,2,0,npc.Position+vel*2+Vector(0, -20),Vector.Zero,npc)
						elseif sprite:GetAnimation() == "BrainSpotlight" then
							d.SpotlightTarget = mod:GetRandomElem(mod:GetAllPlayers())
							local spotlight = Isaac.Spawn(1000, FiendFolio.FF.PropagandaSpotlight.Var, FiendFolio.FF.PropagandaSpotlight.Sub, d.SpotlightTarget.Position, Vector.Zero, npc):ToEffect()
							spotlight:FollowParent(d.SpotlightTarget)
							d.PropagandaSpotlight = spotlight
							game:ShakeScreen(10)
							sfx:Play(mod.Sounds.PropagandaBrainRoar, 1)
						end
					end
					if sprite:IsEventTriggered("Sound") then
						if sprite:GetAnimation() == "BrainLaugh" then
							sfx:Play(mod.Sounds.PropagandaBrainLaugh, 1)
						elseif sprite:GetAnimation() == "BrainMad" then
							sfx:Play(mod.Sounds.PropagandaBrainGroan, 1)
						end
					end
				end
			end
			if sprite:GetAnimation() == "Transition" and sprite:IsFinished() then
				local attack = d.AttackTable[1]
				if attack == 1 then
					d.State = "MaggotCharge"
					sprite:Play("ChargeStart")
					sfx:Play(mod.Sounds.PropagandaNarcAppear, 1)
				elseif attack == 2 then
					d.State = "FortuneOrgan"
					sprite:Play("FortuneShotStart")
					d.ShotsLeft = 30
				elseif attack == 3 then
					d.State = "Fleeing"
					sprite:Play("FleeStart")
				end
				table.remove(d.AttackTable, 1)
				if #d.AttackTable == 0 then
					d.AttackTable = mod:ShuffleTable({1,2,3})
					if d.AttackTable[1] == attack then
						table.remove(d.AttackTable, 1)
						--table.insert(d.AttackTable, attack)
					end
				end
			end
		end
	elseif d.State == "MaggotCharge" then
		if sprite:GetAnimation() == "ChargeStart" then
			if sprite:IsFinished() then
				sprite:Play("Charging")
				sfx:Play(mod.Sounds.PropagandaNarcCharge, 1)
			end
			if sprite:WasEventTriggered("Charge") then
				npc.Velocity = mod:Lerp(npc.Velocity, Vector(15*facingVec, 0), 0.2)
			else
				npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
			end
		end
		if sprite:GetAnimation() == "Charging" then
			npc.Velocity = Vector(15*facingVec, 0)
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			if (not npc.FlipX and npc.Position.X > 720) or (npc.FlipX and npc.Position.X < -100) then
				npc.Position = Vector(320-(400*facingVec), 280)
				sprite:Play("MegaphoneStart")
			end
		end
		if sprite:GetAnimation() == "MegaphoneStart" then
			npc.Velocity = Vector(15*facingVec, 0)
			if room:IsPositionInRoom(npc.Position, -80) then
				sprite:Play("Megaphone")
			end
		end
		if sprite:GetAnimation() == "Megaphone" then
			npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.15)
			if sprite:IsFinished() then
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				sprite:Play("Idle")
				d.State = "Idle"
			else
				if room:IsPositionInRoom(npc.Position, 0) then
					npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				else
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				end
			end
			if sprite:IsEventTriggered("Sound") and sprite:GetFrame() < 3 then
				sfx:Play(mod.Sounds.PropagandaNarcThroatClear, 1)
			else
				sfx:Play(mod.Sounds.PropagandaNarcFeedback, 1)
			end
			if sprite:IsEventTriggered("Shoot") then
				sfx:Play(mod.Sounds.PropagandaNarcMegaphone, 1.5)
				local params = ProjectileParams()
				for i=1.5,50,2 do
					local vel = Vector(1*facingVec,0):Resized(i)/2
					params.Scale = (6+i)/40
					params.BulletFlags = params.BulletFlags | ProjectileFlags.ACCELERATE
					params.Acceleration = 0.95
					local proj = mod:FireProjectiles(npc, npc.Position+Vector(1*facingVec,0):Resized(80), vel:Rotated(mod:getRoll(-50,50, rng)), 0, params)
					proj.FallingAccel = -0.052
				end
				for i=1,10 do
					mod.scheduleForUpdate(function()
						local ran = mod:GetRandomElem{1,-1}
						local chub = mod.spawnent(npc, Vector(math.min(math.max(mod:RandomInt(-80,80)+target.Position.X, 70), 570), 280+ran*170), Vector(0,-1*ran), 39, 22, 1)
						chub:Update()
						mod:GetEntityData(chub).PropagandaSpawn = true
						chub.Color = Color(1, 1, 1, 0, 0, 0, 0)
						Isaac.Spawn(1000,5,0,chub.Position,npc.Velocity:Resized(3):Rotated(mod:RandomInt(-10,10,rng)),npc)
						Isaac.Spawn(1000,2,0,chub.Position,Vector.Zero,npc)
						mod:PlaySound(SoundEffect.SOUND_MEATY_DEATHS, npc, rng:RandomFloat()+1)
						--chub:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					end, i*10)
				end
				for i=0,3 do
					mod:MakeLarynxWave(npc.Position+Vector(1*facingVec,0):Resized(130), 15*i, 10, spawner, Color(2,0.5,0.5,1,1,0,0))
					mod:MakeLarynxLine(npc.Position+Vector(1*facingVec,0):Resized(130), 10*i, 10, spawner, Color(2,0.5,0.5,1,1,0,0))
				end
				for i, player in pairs(mod:GetAllPlayers()) do
					player.Velocity = Vector(20*facingVec, 0)
				end
				game:ShakeScreen(10)
			end
		end
	elseif d.State == "FortuneOrgan" then
		if not d.PropagandaWord or #d.PropagandaWord == 0 then
			if d.ShotsLeft > 0 then
				d.PropagandaWord = StageAPI.WeightedRNG(PropagandaWords)
				if npc.FlipX then
					d.PropagandaWord = d.PropagandaWord:reverse()
				end
			else
				sprite:Play("FortuneShotEnd")
			end
		end
		if sprite:GetAnimation() == "FortuneShotStart" then
			if sprite:IsEventTriggered("Sound") then
				if sprite:GetFrame() < 15 then
					sfx:Play(mod.Sounds.PropagandaPsychoAppear)
				else
					sfx:Play(mod.Sounds.PropagandaPsychoGroan)
				end
			end
			if sprite:IsEventTriggered("Shoot") then
				Isaac.Spawn(1000,2,0,npc.Position+Vector(80*facingVec,-50),Vector.Zero,npc)
				sfx:Play(SoundEffect.SOUND_BONE_BREAK)

				if npc.Position.X > target.Position.X then
					npc.FlipX = true
					facingVec = -1
				else
					npc.FlipX = false
					facingVec = 1
				end
			end
			if sprite:IsFinished() then
				sprite:Play("FortuneShotLoop")
			end
			npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
		end
		if sprite:GetAnimation() == "FortuneShotLoop" then
			npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
		end
		if sprite:GetAnimation() == "FortuneShotEnd" then
			if sprite:IsFinished() then
				sprite:Play("Idle")
				d.State = "Idle"
			end
			if sprite:IsEventTriggered("Sound") then
				sfx:Play(mod.Sounds.PropagandaPsychoToss)
				for i, entry in pairs({Vector(80*facingVec,-20), Vector(-40*facingVec,-20)}) do
					local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position+entry, Vector(-10*facingVec, -10), npc):ToProjectile()
					proj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
					proj:GetSprite():Load("gfx/bosses/propaganda/projectile_organ.anm2", true)
					proj:GetSprite():Play("Move")
					proj.FallingAccel = -0.070
				end
			end
			npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
		end
		if sprite:IsEventTriggered("Shoot") then
			local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, FiendFolio.FF.LetterProjectile.Var, 0, npc.Position+Vector(80*facingVec,-20), Vector((12+mod:RandomInt(-3, 3)), 0):Rotated(mod:getRoll(-20,20, rng)+(target.Position-npc.Position):GetAngleDegrees()), npc):ToProjectile()
			proj.FallingAccel = -0.070
			mod:GetEntityData(proj).PropagandaLetter = string.sub(d.PropagandaWord, #d.PropagandaWord)
			d.PropagandaWord = d.PropagandaWord:sub(0, -2)
			proj:AddProjectileFlags(ProjectileFlags.GHOST)
			--proj.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

			mod:PlaySound(mod.Sounds.ShotgunBlast, npc, math.random(140,200)/100, 0.5)
			d.ShotsLeft = math.max(0, d.ShotsLeft-1)
			npc.Velocity = mod:Lerp(npc.Velocity, Vector(npc.Position.X-(50*facingVec), target.Position.Y)-npc.Position, 0.1)
			if mod:RandomInt(1,3) == 1 then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, 0, npc.Position+Vector(80*facingVec,-20), Vector((8+mod:RandomInt(-3, 3)), 0):Rotated(mod:getRoll(-20,20, rng)+(target.Position-npc.Position):GetAngleDegrees()), npc)
			end
		end
	elseif d.State == "Fleeing" then
		if sprite:GetAnimation() == "FleeStart" then
			if sprite:IsEventTriggered("Sound") then
				if sprite:GetFrame() < 15 then
					sfx:Play(mod.Sounds.PropagandaMachiWhimper, 1.5)
				end
			end
			if sprite:IsEventTriggered("Charge") then
				sfx:Play(mod.Sounds.PropagandaMachiMoan, 1.5)
			end
			if sprite:IsFinished() then
				sprite:Play("Fleeing")
			end
			npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
			d.ColorVal = 1
			d.vec = RandomVector()*10 + Vector(30*facingVec, 0)
			d.PropagandaPapersTimer = 0
		end
		if sprite:GetAnimation() == "Fleeing" or sprite:WasEventTriggered("Charge") then
			d.PropagandaPapersTimer = (d.PropagandaPapersTimer or 0) + 1
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.Velocity = mod:Lerp(npc.Velocity, d.vec, 0.03)
			npc.SpriteOffset = mod:Lerp(npc.SpriteOffset, Vector(0, -100), 0.02)
			d.ColorVal = d.ColorVal or 1
			d.ColorVal = mod:Lerp(d.ColorVal, 0, 0.02)
			npc.Color = Color(d.ColorVal,d.ColorVal,d.ColorVal,1,0,0,0)
			npc.Scale = mod:Lerp(npc.Scale, 3, 0.005)
			local room = game:GetRoom()
			if (npc.Position.X < -100 or npc.Position.X > room:GetGridWidth()*40+100 or npc.Position.Y > room:GetGridHeight()*40+300 or npc.Position.Y < -300) and not RenderPapers then
				npc.Visible = false
				RenderPapers = true

				PaperSprite:Play("Enter", true)
				PaperSprite2:Play("Enter", true)

				mod:PlaySound(SoundEffect.SOUND_SHELLGAME, npc, 1.2)
			end
			if RenderPapers and npc.FrameCount % 10 == 0 and d.PropagandaPapersTimer < 150 and d.PropagandaPapersTimer > 25 then
				local word = StageAPI.WeightedRNG(PropagandaWords)
				local wordDir = 1
				local wordVert = mod:RandomInt(150, 410)
				local speed = mod:RandomInt(-2, 1)
				if d.PropagandaPapersTimer > 100 then
					speed = speed + 1
				end
				if mod:RandomInt(1,2) == 1 then
					wordDir = -1
					word = word:reverse()
				end
				for i = 1, #word do
					local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, FiendFolio.FF.LetterProjectile.Var, 0, Vector(320+(wordDir*150)+(i*20*wordDir), wordVert), Vector((6+speed)*wordDir*-1, 0), npc):ToProjectile()
					mod:GetEntityData(proj).PropagandaLetter = word:sub(i,i)
					proj.FallingAccel = -0.090
					proj:AddProjectileFlags(ProjectileFlags.WIGGLE)
					proj.WiggleFrameOffset = i*2
					proj.CurvingStrength = 0.1
				end
			end
			--print(RenderPapers, Isaac.CountEntities(npc, 9, FiendFolio.FF.LetterProjectile.Var) == 0, d.PropagandaPapersTimer)
			if RenderPapers and Isaac.CountEntities(npc, 9, FiendFolio.FF.LetterProjectile.Var) == 0 and d.PropagandaPapersTimer > 100 then
				PaperSprite:Play("Exit")
				PaperSprite2:Play("Exit")
				npc.Position = Vector(320+mod:GetRandomElem{-1, 1}*230, 280)
				npc.Velocity = Vector.Zero
				--mod:FlipSprite(sprite, npc.Position, room:GetCenterPos())
				sprite:Play("Idle")
				d.State = "Idle"
				npc.Visible = true
				npc.Color = Color.Default
				npc.Scale = 1
				npc.SpriteOffset = Vector.Zero
				d.PropagandaPapers = {}
				mod:PlaySound(SoundEffect.SOUND_SHELLGAME, npc, 1)
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end
		end
	elseif d.State == "PhaseTrans" then
		if sprite:IsFinished() then
			sprite:Play("BrainIdle")
			d.State = "Idle"
		end
		if sprite:IsEventTriggered("Sound") and sprite:GetFrame() < 15 then
			sfx:Play(mod.Sounds.PropagandaPhaseTrans, 1.3)
		end
		if sprite:IsEventTriggered("Shoot") then
			d.Phase2BossBarIcon = true
			sfx:Play(mod.Sounds.PropagandaBrainSpawn, 1.3)
			for i, entry in pairs({"Narc", "Machi", "Psycho"}) do
				local face = Isaac.Spawn(FiendFolio.FFID.Boss, mod.FF.Propaganda.Var, 2, npc.Position, Vector.Zero, npc):ToNPC()
				mod:GetEntityData(face).ParentPropaganda = npc
				mod:GetEntityData(face).PropagandaFace = entry
				table.insert(d.PropagandaFaces, face)
				face.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				face:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				face:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			end
			local horse = Isaac.Spawn(FiendFolio.FFID.Boss, mod.FF.Propaganda.Var, 1, npc.Position + Vector(30, 0), Vector.Zero, npc):ToNPC()
			horse:GetSprite():Play("Appear")
			horse.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			horse:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			horse:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			
			sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE)
			Isaac.Spawn(1000,77,0,npc.Position,Vector.Zero,npc)
		end
		if sprite:WasEventTriggered("Shoot") then
			d.FaceAngle = d.FaceAngle + 1
		end
		npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
	end
	local facesaligned = 0
	for i, face in pairs(d.PropagandaFaces) do
		local offset = (360/3) * i
		local targetvec
		local cap = 20
		if d.FaceState == "Idle" then
			targetvec = (npc.Position + Vector(0, math.min(d.FaceAngle+10, 50+math.sin(d.FaceAngle/5)*5)):Rotated(-d.FaceAngle*1.7 + offset + 180)) - face.Position
			face.Visible = true
		elseif d.FaceState == "Ready" then
			targetvec = d.FaceTargetPos + Vector(0, 140-d.FaceTimer*1.5):Rotated(-d.FaceAngle*1.7 + offset + 180) - face.Position
			if (d.FaceTargetPos + Vector(0, 140-d.FaceTimer*1.5):Rotated(-d.FaceAngle*1.7 + offset + 180)):Distance(face.Position) < 20 and d.FaceTargetPos:Distance(target.Position) < 3 then
				facesaligned = facesaligned + 1
			end
			d.FaceTargetPos = d.FaceTargetPos + (target.Position+target.Velocity-d.FaceTargetPos):Resized(math.max(math.min((60-d.FaceTimer)/10, 2.5), 0))
			if d.FaceTargetPos:Distance(target.Position) < 3 then
				d.FaceTargetPos = target.Position
			end
		elseif d.FaceState == "Charge" then
			targetvec = d.FaceTargetPos - face.Position
			cap = 13-d.FaceTimer
			if d.FaceTargetPos:Distance(face.Position) < 20 then
				facesaligned = facesaligned + 1
			end
		elseif d.FaceState == "Clump" then
			targetvec = Vector.Zero
		elseif d.FaceState == "Unclump" then
			if d.FaceTimer == 0 then
				targetvec = d.FaceTargetPos + Vector(0, 50):Rotated(-d.FaceAngle*1.7 + offset + 180) - face.Position
				if d.FaceTargetPos:Distance(npc.Position) < 3 then
					d.FaceState = "Idle"
					d.FaceTimer = mod:RandomInt(200, 400)
				end
				d.FaceTargetPos = d.FaceTargetPos + (npc.Position+npc.Velocity-d.FaceTargetPos):Resized(2.5)
			else
				targetvec = d.FaceTargetPos + Vector(0, 50):Rotated(offset + 180) - face.Position
				cap = 0
				d.FaceAngle = 210
			end
		end

		face.Velocity = mod:CappedVector(targetvec, cap)
		if d.FaceState == "Unclump" then
			face.Velocity = mod:Lerp(face.Velocity, targetvec, 0.1)
		end

		face.SpriteOffset = Vector(0, math.min(0, -20+d.FaceAngle/5))

		if d.FaceState == "Idle" and d.FaceTimer == 0 and d.FaceAngle % 360 < 190 and d.FaceAngle % 360 > 180 then
			d.FaceState = "Ready"
			d.FaceTargetPos = npc.Position
			d.FaceTimer = 60
		end
		if facesaligned == 3 and d.FaceState == "Charge" then
			d.FaceState = "Clump"
			local params = ProjectileParams()
			local proj = mod:FireProjectiles(npc, face.Position, Vector(10, 12), 9, params)
			sfx:Play(SoundEffect.SOUND_BLOODSHOOT)
			sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS)
		end
		if i == 1 and face:GetSprite():GetAnimation() == "NarcSE" and d.FaceTimer == 0 and d.FaceState == "Ready" then
			d.FaceTargetPos = target.Position
			d.FaceState = "Charge"
			d.FaceTimer = 20
			--sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_1)
		end
		if face:GetSprite():IsEventTriggered("Unclump") then
			d.FaceState = "Unclump"
			d.FaceTimer = 20
			sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
			Isaac.Spawn(1000,2,0,face.Position,Vector.Zero,npc)
		end
	end

	PaperSprite:Update()
	PaperSprite2:Update()

	if PaperSprite:GetAnimation() == "Exit" and PaperSprite:IsFinished() then
		RenderPapers = false
	end
end

function mod:PropagandaFaceAI(npc, sprite, d)
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	--print(d.PropagandaFace, NearestDirection((npc.Position-d.ParentPropaganda.Position):GetAngleDegrees()))
	if d.ParentPropaganda:IsDead() then
		if sprite:GetAnimation() ~= d.PropagandaFace.."Death" then
			npc:GetSprite():Play(d.PropagandaFace.."Death")
		elseif sprite:IsFinished() then
			npc:Kill()
		end
		npc.Velocity = Vector.Zero
	elseif mod:GetEntityData(d.ParentPropaganda).FaceState == "Idle" then
		sprite:Play(d.PropagandaFace..NearestDirection((npc.Position-d.ParentPropaganda.Position):GetAngleDegrees()+90))
	elseif mod:GetEntityData(d.ParentPropaganda).FaceState == "Ready" then
		sprite:Play(d.PropagandaFace..NearestDirection((npc.Position-mod:GetEntityData(d.ParentPropaganda).FaceTargetPos):GetAngleDegrees()+90))
	elseif mod:GetEntityData(d.ParentPropaganda).FaceState == "Charge" and sprite:GetAnimation() ~= d.PropagandaFace.."Dash" then
		sprite:Play(d.PropagandaFace.."Dash")
	elseif mod:GetEntityData(d.ParentPropaganda).FaceState == "Clump" then
		if d.PropagandaFace == "Narc" then
			if sprite:GetAnimation() ~= "FaceClump" then
				sprite:Play("FaceClump")
			end
		else
			npc.Visible = false
		end
	elseif mod:GetEntityData(d.ParentPropaganda).FaceState == "Unclump" then
		sprite:Play(d.PropagandaFace..NearestDirection((npc.Position-mod:GetEntityData(d.ParentPropaganda).FaceTargetPos):GetAngleDegrees()+90))
		npc.Visible = true
	end
end

function mod:PropagandaHorseAI(npc, sprite, d)
	local room = game:GetRoom()
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	d.FortuneTimer = d.FortuneTimer or mod:RandomInt(90, 120)
	d.FortunesSinceSpecial = d.FortunesSinceSpecial or 0
	npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

	local facingVec = 1
	if npc.FlipX then
		facingVec = -1
	end

	if sprite:IsFinished() then
		sprite:Play("Charging")
		sfx:Play(mod.Sounds.PropagandaHorse, 0.5)
	end
	if sprite:GetAnimation() == "Charging" or sprite:WasEventTriggered("Charge") then
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(13*facingVec, 0), 0.3)
	else
		npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
	end

	if d.FortuneTimer <= 0 then
		d.FortuneTimer = mod:RandomInt(180, 270)
		if not npc.FlipX then
			npc.FlipX = true
		else
			npc.FlipX = false
		end
		npc.Position = Vector(320+450*facingVec, mod:GetRandomElem{180, 280, 390})
		--mod.scheduleForUpdate(function()
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, FiendFolio.FF.PropagandaFortune.Var, FiendFolio.FF.PropagandaFortune.Sub, Vector(npc.Position.X+150*facingVec, npc.Position.Y), Vector.Zero, npc)
			if npc.FlipX then
				effect:GetSprite().FlipX = true
			end
			if d.FortunesSinceSpecial > 0 then
				local purplechancemod = math.max(0, (Isaac.CountEnemies()-5)*0.1)
				local chanceMult = 1.0 + ((d.FortunesSinceSpecial - 1) * 0.5)
				local ran = rng:RandomFloat()

				if ran <= (0.25 * chanceMult) - purplechancemod then
					mod:GetEntityData(effect).Type = 1
					d.FortunesSinceSpecial = 0
				elseif ran <= 0.5 * chanceMult then
					mod:GetEntityData(effect).Type = 2
					d.FortunesSinceSpecial = 0
				else
					d.FortunesSinceSpecial = d.FortunesSinceSpecial + 1
				end
			else
				d.FortunesSinceSpecial = d.FortunesSinceSpecial + 1
			end
		--end, 5)
	end
	
	if npc.SpawnerEntity and npc.SpawnerEntity:IsDead() and not room:IsPositionInRoom(npc.Position, -100) and ((npc.Position.X > 0 and facingVec == 1) or (npc.Position.X < 0 and facingVec == -1)) then
		npc:Remove()
	end
	d.FortuneTimer = d.FortuneTimer - 1
end

function mod:PropagandaExtraHurt(npc, amount)
	if npc.SubType ~= 0 then
		return false
	elseif mod:GetEntityData(npc).State == "PhaseTrans" or (npc.HitPoints <= npc.MaxHitPoints/2 and mod:GetEntityData(npc).Phase == 0) then
		return {Damage = mod:Lerp(amount, 0, (npc.MaxHitPoints/2 - npc.HitPoints)*0.01)}
	end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local d = mod:GetEntityData(npc)
	if d.PropagandaSpawn then
		npc.Color = Color.Lerp(npc.Color, Color.Default, 0.3)
		npc.Velocity = npc.Velocity*npc.FrameCount*0.5
	end
end, 39)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	if effect.SubType ~= FiendFolio.FF.PropagandaFortune.Sub then
		return
	end

	local d = mod:GetEntityData(effect)
	local sprite = effect:GetSprite()

	if not d.init then
		d.FortuneText = StageAPI.WeightedRNG(PropagandaFortunes)
		effect.DepthOffset = 1000
		effect.Visible = false

		if #d.FortuneText == 2 then
			sprite:Play("Text2")
		elseif #d.FortuneText == 3 then
			sprite:Play("Text3")
		end

		if d.Type == 1 then
			sprite:ReplaceSpritesheet(0, "gfx/bosses/propaganda/Fortune_Fiendish.png", true)
			d.FiendishFortune = true
		elseif d.Type == 2 then
			sprite:ReplaceSpritesheet(0, "gfx/bosses/propaganda/Fortune_bloody.png", true)
			d.BloodyFortune = true
			d.FortuneProjectiles = {}

			local word = StageAPI.WeightedRNG(PropagandaWords)
			--[[if sprite.FlipX then
				word = word:reverse()
			end]]
			for i = 1, #word do
				local offset = Vector((i-(#word+1)/2)*22, 20)
				if #d.FortuneText == 2 then
					offset = offset + Vector(0, 15)
				elseif #d.FortuneText == 3 then
					offset = offset + Vector(0, 30)
				end
				--[[local centerpos = Isaac.ScreenToWorld(sprite:GetNullFrame("Center"):GetPos())
				if sprite.FlipX then
					centerpos = centerpos*Vector(-1, 1)
					offset = offset + Vector(-160, 0)
				end]]
				local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, FiendFolio.FF.LetterProjectile.Var, 0, effect.Position + offset, Vector.Zero, effect.SpawnerEntity):ToProjectile()
				mod:GetEntityData(proj).PropagandaLetter = word:sub(i,i)
				mod:GetEntityData(proj).FortuneOffset = offset
				mod:GetEntityData(proj).SpawnerHorse = effect.SpawnerEntity:ToNPC()
				mod:GetEntityData(proj).NoCollide = true
				proj.FallingAccel = -0.090
				proj:AddProjectileFlags(ProjectileFlags.GHOST)
				proj.DepthOffset = 2000
				table.insert(d.FortuneProjectiles, proj)
			end

			d.FortuneText = nil
		end

		d.init = true
	end

	--[[if d.FiendishFortune and effect.FrameCount % 4 == 0 then
		local pos = Isaac.ScreenToWorld(sprite:GetNullFrame("Center"):GetPos()) + effect.Position + Vector(0, -80) + Vector(mod:RandomInt(-100, 100), 0)
		local offset = mod:Lerp(pos, effect.Position+Vector(0, -80), -0.3)

		local haemo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, offset, (offset-pos):Resized(5), effect):ToEffect()
		haemo.Color = FiendFolio.ColorMausPurple
		haemo.SpriteScale = haemo.SpriteScale*0.5
	end]]

	if effect.SpawnerEntity then
		local facingVec = 1
		if effect.SpawnerEntity.FlipX then
			facingVec = -1
		end
		if effect.Position.X < 310 or effect.Position.X > 330 then
			local offset = 0
			if sprite:GetAnimation() == "Text2" then
				offset = -20
			elseif sprite:GetAnimation() == "Text3" then
				offset = -40
			end
			effect.Velocity = (effect.SpawnerEntity.Position+Vector(-200*facingVec, offset)) - effect.Position
		else
			effect.Velocity = Vector.Zero
		end
	end

	if d.BloodyFortune and sprite:GetFrame() < 90 then
		for i, proj in pairs(d.FortuneProjectiles) do
			if proj:Exists() then
				--[[local centerpos = Isaac.ScreenToWorld(sprite:GetNullFrame("Center"):GetPos())
				if sprite.FlipX then
					centerpos = centerpos*Vector(-1, 1)
				end]]
				proj.Velocity = mod:Lerp(proj.Velocity, effect.Position + mod:GetEntityData(proj).FortuneOffset - proj.Position, 0.85)
			end
		end
	end

	if sprite:IsFinished() then
		effect:Remove()
	end

	if sprite:IsEventTriggered("SlideIn") then
		mod:PlaySound(SoundEffect.SOUND_SHELLGAME, effect, 1.2)
	end
	if sprite:IsEventTriggered("SlideOut") then
		mod:PlaySound(SoundEffect.SOUND_SHELLGAME, effect, 1)

		if d.FiendishFortune then
			local tospawn = 3 --mod:RandomInt(2, 3)

			local totalSpawnHP = 0
			for i = 1, tospawn do
				local id = StageAPI.WeightedRNG(PropagandaSpawns)
				if totalSpawnHP >= 50 then
					id = {EntityType.ENTITY_LEPER, 1, 0}
				end
				local entity = Isaac.Spawn(id[1], id[2] or 0, id[3] or 0, Vector(effect.Position.X + mod:RandomInt(-200, 200), effect.Position.Y + mod:RandomInt(-10, 10)), Vector.Zero, effect)
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				totalSpawnHP = totalSpawnHP + entity.HitPoints
			end

			for i = 1, 10 do
				local haemo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, Vector(effect.Position.X + mod:RandomInt(-200, 200), effect.Position.Y + mod:RandomInt(-30, 30)), Vector(-5,0)+RandomVector()*3, effect):ToEffect()
				haemo.Color = FiendFolio.ColorMausPurple
				haemo.SpriteScale = haemo.SpriteScale*0.5
			end
		end
		if d.BloodyFortune then
			for i, proj in pairs(d.FortuneProjectiles) do
				mod.scheduleForUpdate(function()
					if proj:Exists() then
						proj.Velocity = Vector(4, 0):Rotated((mod:GetEntityData(proj).SpawnerHorse:GetPlayerTarget().Position-proj.Position):GetAngleDegrees())
						--mod:PlaySound(mod.Sounds.ShotgunBlast, npc, math.random(140,200)/100, 0.5)
						mod:GetEntityData(proj).NoCollide = false
						proj:AddProjectileFlags(ProjectileFlags.ACCELERATE)
						proj.Acceleration = 1.10
					end
				end, 5*i)
			end
		end
	end
end, FiendFolio.FF.PropagandaFortune.Var)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, function(_, proj)
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, proj.Position+proj.PositionOffset, Vector.Zero, proj):ToEffect()
	effect.SpriteScale = effect.SpriteScale*0.375
end, FiendFolio.FF.LetterProjectile.Var)

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_GRID_COLLISION, function(_, proj, idx, grid)
	if game:GetRoom():GetGridCollision(idx) < GridCollisionClass.COLLISION_WALL then
		return true
	end
end, FiendFolio.FF.LetterProjectile.Var)

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, proj)
	if mod:GetEntityData(proj).NoCollide then
		return true
	end
end, FiendFolio.FF.LetterProjectile.Var)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_RENDER, function(_, proj)
	local d = mod:GetEntityData(proj)
	if d.PropagandaLetter then
		local pos = Isaac.WorldToScreen(proj.Position + Vector(-7,-45))
		local count = 0
		for i, entry in pairs({Vector(1,0),Vector(-1,0),Vector(0,1),Vector(0,-1)}) do
			font:DrawString(d.PropagandaLetter, pos.X+entry.X, pos.Y+entry.Y, KColor.White)
		end
		if proj.SpawnerEntity then
			count = proj.SpawnerEntity.FrameCount
		end
		font:DrawString(d.PropagandaLetter, pos.X, pos.Y, KColorLerp(KColor.Black, KColor.Red, math.sin(count/4)))
	end
end, FiendFolio.FF.LetterProjectile.Var)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	if mod:GetEntityData(npc).PropagandaVel then
		npc.Velocity = mod:GetEntityData(npc).PropagandaVel
		if npc:CollidesWithGrid() then
			npc:TakeDamage(100, 0, EntityRef(npc), 1)
		end
	end
end, EntityType.ENTITY_LEPER)

local promptcrop = {[Direction.LEFT] = Vector(64, 0), [Direction.UP] = Vector(-32, 0), [Direction.RIGHT] = Vector(0, 0), [Direction.DOWN] = Vector(32, 0)}
local promptaction = {[Direction.LEFT] = ButtonAction.ACTION_SHOOTLEFT, [Direction.UP] = ButtonAction.ACTION_SHOOTUP, [Direction.RIGHT] = ButtonAction.ACTION_SHOOTRIGHT, [Direction.DOWN] = ButtonAction.ACTION_SHOOTDOWN}
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function(_)
	if RenderPapers == true then
		if Isaac.CountEntities(nil, FiendFolio.FF.Propaganda.ID, FiendFolio.FF.Propaganda.Var) > 0 then
			PaperSprite:Render(Isaac.WorldToScreen(Vector(100,250)))
			PaperSprite2:Render(Isaac.WorldToScreen(Vector(560,250)))
		else
			RenderPapers = false
		end
	end

	for i, effect in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, FiendFolio.FF.PropagandaSpotlight.Var, FiendFolio.FF.PropagandaSpotlight.Sub)) do
		local sprite = effect:GetSprite()
		local d = mod:GetEntityData(effect)

		if not effect.SpawnerEntity then
			break
		end

		local propdata = mod:GetEntityData(effect.SpawnerEntity)

		if propdata.SpotlightFail then
			break --Incredible code on display here
		end
		for _, action in pairs(inputs) do
			if Input.IsActionTriggered(action, propdata.SpotlightTarget.ControllerIndex) and #propdata.PropagandaPrompts > 0 then
				if not propdata.PromptBlunder then
					if action == promptaction[propdata.PropagandaPrompts[1]] then
						propdata.PromptWin = table.remove(propdata.PropagandaPrompts, 1)
						propdata.SpotlightFrame = 0
						sfx:Play(SoundEffect.SOUND_THUMBSUP, 0.33, 0, false, 1.7 - (#propdata.PropagandaPrompts * 0.1))
					else
						for dir, action2 in pairs(promptaction) do
							if action == action2 then
								propdata.PromptBlunder = dir
								sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.33, 0, false, mod:RandomInt(8,12) * 0.1)
							end
						end
						propdata.PromptWin = nil
						propdata.SpotlightFrame = 0
					end
				end
			end
			if propdata.SpotlightFrame > 10 and propdata.PromptBlunder then
				propdata.PromptBlunder = false
			end
		end
		for i = 1, 3 do
			local val = i
			if propdata.PromptWin then
				val = val + math.max(0, 1.1-propdata.SpotlightFrame/10)
			end
			if propdata.PropagandaPrompts[i] then
				local offset = Vector(-40, -35) + Vector(0, -25*val)
				--print(promptcrop[propdata.PropagandaPrompts[i]], PromptSprite:GetLayer(0))
				PromptSprite.Color = Color.Lerp(Color(1,1,1,0,0,0,0), Color.Default, math.min(1/val^2, effect.FrameCount/40))
				PromptSprite:Play("Idle")
				PromptSprite:SetFrame(0)
				PromptSprite:GetLayer(0):SetCropOffset(promptcrop[propdata.PropagandaPrompts[i]])
				if propdata.PromptBlunder and i == 1 then
					PromptSprite:Play("Fail")
					PromptSprite:GetLayer(0):SetCropOffset(promptcrop[propdata.PromptBlunder])
					PromptSprite:SetFrame(math.min(propdata.SpotlightFrame, 10))
				end
				PromptSprite:Render(Isaac.WorldToScreen(effect.Position + offset))
			end
		end
		if propdata.PromptWin then
			PromptSprite:Play("Win")
			PromptSprite.Color = Color.Default
			PromptSprite:GetLayer(0):SetCropOffset(promptcrop[propdata.PromptWin])
			PromptSprite:SetFrame(math.min(propdata.SpotlightFrame, 10))
			PromptSprite:Render(Isaac.WorldToScreen(effect.Position + Vector(-40, -60)))
		end
	end
	for i, effect in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, FiendFolio.FF.PropagandaFortune.Var, FiendFolio.FF.PropagandaFortune.Sub)) do
		local sprite = effect:GetSprite()
		local d = mod:GetEntityData(effect)
		sprite:Render(Isaac.WorldToScreen(effect.Position))
		if d.FortuneText then
			for i, text in pairs(d.FortuneText) do
				local centerpos = sprite:GetNullFrame("Center"):GetPos()
				if sprite.FlipX then
					centerpos = centerpos * Vector(-1, 1)
				end
				local scale = sprite:GetLayer("Main"):GetSize()
				local pos = centerpos + Isaac.WorldToScreen(effect.Position + Vector(0, -25 + 35*(i-1)))
				font:DrawStringScaled(text, pos.X, pos.Y, scale.X, scale.Y, KColor.Black, 1, true)
			end
		end

		if d.BloodyFortune then
			for i, proj in pairs(d.FortuneProjectiles) do
				if mod:GetEntityData(proj).PropagandaLetter then
					local pos = Isaac.WorldToScreen(proj.Position + Vector(-7,-45))
					for i, entry in pairs({Vector(1,0),Vector(-1,0),Vector(0,1),Vector(0,-1)}) do
						font:DrawString(mod:GetEntityData(proj).PropagandaLetter, pos.X+entry.X, pos.Y+entry.Y, KColor.White)
					end
					font:DrawString(mod:GetEntityData(proj).PropagandaLetter, pos.X, pos.Y, KColorLerp(KColor.Black, KColor.Red, math.sin(effect.FrameCount/4)))
				end
			end
		end
	end
end)

local portraitSound = false
StageAPI.AddCallback("FiendFolio", "POST_HUD_RENDER", 1, function()
	local stageApiPlaying = StageAPI.PlayingBossSprite ~= nil and StageAPI.PlayingBossSprite:IsPlaying()
	local vanillaPlaying = RoomTransition.IsRenderingBossIntro()
	if (stageApiPlaying or vanillaPlaying) and mod:GetStageAPIBossID() == "Propaganda" then
		local sprite = stageApiPlaying and StageAPI.PlayingBossSprite or RoomTransition.GetVersusScreenSprite()

		local name = Isaac.GetPlayer(0):GetName()
		if name == "???" then
			name = "BlueBaby"
		end
		if name == "Black Judas" then
			name = "Judas"
		end
		PortraitSprite:ReplaceSpritesheet(0, "gfx/bosses/propaganda/player_portraits/"..name..".png", true)
		NameSprite:ReplaceSpritesheet(0, "gfx/bosses/propaganda/player_portraits/PlayerName_"..name..".png", true)

		if PortraitSprite:GetTexel(Vector.Zero, Vector.Zero, 1, 0).Alpha == 0 then --I have no idea if there's a better way to check if a spritesheet exists
			PortraitSprite:ReplaceSpritesheet(0, "gfx/bosses/propaganda/player_portraits/Incompatible.png", true)
			NameSprite:ReplaceSpritesheet(0, "gfx/bosses/propaganda/player_portraits/PlayerName_Incompatible.png", true)
		end

		if sprite:GetFrame() >= 15 then
			if not portraitSound then
				sfx:Play(mod.Sounds.PropagandaDeco)
				portraitSound = true
			end
			PortraitSprite:Play("Spawn", true)
			PortraitSprite:SetFrame(math.min(sprite:GetFrame()-15, 6))

			NameSprite:Play("Spawn", true)
			NameSprite:SetFrame(math.min(sprite:GetFrame()-20, 6))
		end
		if sprite:GetFrame() >= 83 then
			PortraitSprite:Play("Disappear", true)
			PortraitSprite:SetFrame(math.min(sprite:GetFrame()-83, 7))

			NameSprite:Play("Disappear", true)
			NameSprite:SetFrame(math.min(sprite:GetFrame()-83, 7))
		end
		--PortraitSprite:Play("Idle")

		--print(PortraitSprite:GetLayer(0):GetSpritesheetPath())
		if sprite:GetFrame() >= 15 then
			PortraitSprite:Render(Vector(120, 210))
			NameSprite:Render(Vector(95, 50))
		end
	elseif portraitSound and not vanillaPlaying then
		portraitSound = false
	end
end, 2)

mod:AddCallback(ModCallbacks.MC_POST_GAME_END, function(_, gameOver)
	if gameOver then
		if #Isaac.FindByType(mod.FF.Propaganda.ID, mod.FF.Propaganda.Var) > 0 then
			if inPhase2 then
				sfx:Play(mod.Sounds.PropagandaKillLaugh2, 1, 0, false, 1)
			else
				sfx:Play(mod.Sounds.PropagandaKillLaugh, 1.5, 0, false, 1)
			end
		end
	end
end)
