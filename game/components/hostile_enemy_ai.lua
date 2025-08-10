HostileEnemyAI = AiComponent:extend()

function HostileEnemyAI:new(entity) HostileEnemyAI.super.new(self, entity) end

function HostileEnemyAI:perform(target_x, target_y) self:move_along_path(target_x, target_y) end
