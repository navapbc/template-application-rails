class UserRole < ApplicationRecord
  # == Enums ================================================================
  # See `technical-foundation.md#enums` for important note about enums.
  enum :role, { claimant: 0, employer: 1 }, default: :claimant, validate: true

  # == Relationships ========================================================
  belongs_to :user
end
