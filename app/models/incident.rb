class Incident < ApplicationRecord
  enum severity: {
    sev0: 0,
    sev1: 1,
    sev2: 2
  }

  enum status: {
    open: 0,
    resolved: 1
  }
end
