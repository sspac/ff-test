local mod = FiendFolio



function mod:RatBombsLoadCompatibility()
	if BossButch then
		-- Parallel Bombs
		table.insert(BossButch.RatBombs.BodySprites, { Condition = "ParallelBombClone",  Suffix = "steven", })
		table.insert(BossButch.RatBombs.BodySprites, { Condition = "ParallelBombParent", Suffix = "steven", })

		function mod:ParallelRatBombPreConvert(bomb, rat)
			local bombData = mod:GetEntityData(bomb)
			local parent = bombData.ParallelBombParent
			local clone = bombData.ParallelBombCloneRat

			-- Make sure the parent can find me
			if parent then
				rat:GetSprite():SetCustomShader("shaders/fiendfolio/coloroffset_parallel")
				mod:GetEntityData(parent).ParallelBombCloneRat = rat

			-- Set the clone's parent
			elseif clone then
				mod:GetEntityData(clone).ParallelBombParent = rat
			end
		end
		mod:AddCallback(BossButch.RatBombCallbacks.PreConvert, mod.ParallelRatBombPreConvert)

		function mod:ParallelRatBombPreUpdate(rat)
			if mod:GetEntityData(rat).ParallelBombParent then
				local parent = mod:GetEntityData(rat).ParallelBombParent

				-- Mirror the parent's position
				rat.Position = mod:GetMirroredPosition(parent.Position)
				rat.Velocity = -parent.Velocity

				-- Copy the state
				rat.State = parent.State
				rat.Visible = parent.Visible

				if parent:IsDead() then
					rat:Kill()
				end

				-- Copy sprite stuff
				local cloneSprite = rat:GetSprite()
				local parentSprite = parent:GetSprite()

				local originalDirection = BossButch:GetDirectionString(parent.Velocity:GetAngleDegrees(), true)
				local newDirection = BossButch:GetDirectionString(rat.Velocity:GetAngleDegrees(), true)
				local animation = parentSprite:GetAnimation():gsub(originalDirection, newDirection)
				cloneSprite:Play(animation, true)

				cloneSprite:SetFrame(parentSprite:GetFrame())
				cloneSprite.FlipX = not parentSprite.FlipX

				-- Stay intangible
				rat.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				rat.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

				return true
			end
		end
		mod:AddCallback(BossButch.RatBombCallbacks.PreStateUpdate, mod.ParallelRatBombPreUpdate)



		-- Chaos Bombs
		local chaosBombPassives = {
			[ "CHAOS_MAGNET_BOMB" ] = mod.ChaosBombsMagnetPassive,
			[ "CHAOS_ICE_BOMB" ] 	= mod.ChaosBombsIcePassive,
			[ "CHAOS_BUBBLE_BOMB" ] = mod.ChaosBombsBubblePassive,
		}

		function mod:ChaosRatBombUpdate(rat)
			local bombData = mod:GetEntityData(rat).StoredData

			if bombData then
				local tearFlagData = bombData[TearFlagsLib.DataKey]

				for flagName, script in pairs(chaosBombPassives) do
					local flags = TearFlagsLib.Flag[flagName]

					-- Do a manual check for the flag
					if tearFlagData.tearFlags & flags == flags then
						script(self, rat.Player, rat)
					end
				end
			end
		end
		mod:AddCallback(BossButch.RatBombCallbacks.PostUpdate, mod.ChaosRatBombUpdate)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.RatBombsLoadCompatibility)