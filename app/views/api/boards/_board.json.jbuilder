json.extract! board, :id, :title, :description
json.phases board.phases, partial: "api/phases/phase", as: :phase
