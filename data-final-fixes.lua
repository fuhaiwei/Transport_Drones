local shared = require("shared")
local collision_mask_util = require("collision-mask-util")

local road_tile = data.raw.tile["transport-drone-road"]
local road_tile_proxy = data.raw.tile["transport-drone-proxy-tile"]
local road_item = data.raw.item.road

local road_collision_layer = collision_mask_util.get_first_unused_layer()
road_tile.collision_mask = {road_collision_layer}

road_tile_proxy.collision_mask = {"ground-tile"}

road_item.place_as_tile =
{
  result = road_tile_proxy.name,
  condition_size = 1,
  condition = {"water-tile", road_collision_layer}
}

for k, prototype in pairs (collision_mask_util.collect_prototypes_with_layer("player-layer")) do
  if prototype.type ~= "gate" then
    local mask = collision_mask_util.get_mask(prototype)
    if collision_mask_util.mask_contains_layer(mask, "item-layer") then
      collision_mask_util.add_layer(mask, road_collision_layer)
    end
    prototype.collision_mask = mask
  end
end

shared.drone_collision_mask = {"ground-tile", "water-tile", "colliding-with-tiles-only", "consider-tile-transitions"}

local util = require "__Transport_Drones__/data/tf_util/tf_util"
require("data/entities/transport_drone/transport_drone")
require("data/make_request_recipes")
