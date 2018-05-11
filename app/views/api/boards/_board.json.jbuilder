json.extract! board, :id, :title, :description
json.phases board.boards_phases do |board_phase|
  json.partial! "api/phases/phase", phase: board_phase.phase
  json.final board_phase.final
end
