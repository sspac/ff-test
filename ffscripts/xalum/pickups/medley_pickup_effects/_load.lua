local toLoad = {
	"cursed_penny",
	"haunted_penny",
	"honey_penny",
	"lucky_penny",
}

for _, path in pairs(toLoad) do
	include("ffscripts.xalum.pickups.medley_pickup_effects." .. path)
end