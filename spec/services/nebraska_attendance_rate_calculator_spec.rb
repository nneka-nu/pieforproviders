# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NebraskaAttendanceRateCalculator, type: :service do
  describe 'when calling the attendance rate calculator' do
    before do
      travel_to Date.parse('December 11th, 2020')
      create(:illinois_approval_amount,
             part_days_approved_per_week: 2,
             full_days_approved_per_week: 0,
             child_approval: single_child_family.child_approvals.first,
             month: DateTime.now.in_time_zone('Central Time (US & Canada)'))
      create_list(:illinois_part_day_attendance, 3, child_approval: single_child_family.child_approvals.first)
      multiple_child_family_approval.children.each do |child|
        create(:illinois_approval_amount,
               part_days_approved_per_week: 2,
               full_days_approved_per_week: 0,
               child_approval: child.child_approvals.first,
               month: DateTime.now.in_time_zone('Central Time (US & Canada)'))
        create_list(:illinois_part_day_attendance, 3, child_approval: child.child_approvals.first)
      end
    end
    after { travel_back }

    it 'calculates the rate for within_limits' do
    end

    #     Test Case 1 – “Within limits”
    # Input: (15, 10, 0, 10, 3, 5, False)
    # Output: (0.667, 0.6, ‘Within Limits’)
    # Test Case 2 – “Daily already exceeds”
    # Input: (5, 9, 2, 10, 5, 0, False)
    # Output: (3.0, 0.5, ‘Exceeds Limits’)
    # Test Case 3 – “Hourly projected to exceed”
    # Input: (10, 0, 10, 10, 6, 7, True)
    # Output: (0, 2.0, ‘At Risk)

    # Revenue Projections
    # Input Format (all floats/ints): (scheduled_revenue, scheduled_daily_units, completed_daily_units, daily_units_remaining, daily_rate, scheduled_hourly_units, completed_hourly_units, hourly_units_remaining, hourly_rate, enrollment_fee, transportation_fees, activity_fee)
    # Output: (earned_revenue, estimated_revenue, status)
    # Output Types: (Float, Float, String)

    # Test Case 1 – “Finished, Within Limits”
    # Input: (600, 10, 10, 0, 50, 0, 0, 0, 10, 0, 100, 0)
    # Output: (600, 600, ‘Within Limits’)
    # Test Case 2 – “On Pace / Within Limits”
    # Input: (650, 10, 5, 5, 50, 5, 0, 5, 10, 0, 100, 0)
    # Output: (600, 650, ‘Exceeds Limits’)
    # Test Case 3 – “Daily Projected Outside, Projected On-Track in Aggregate”
    # Input: (650, 8, 8, 4, 50, 10, 0, 0, 20, 0, 100, 0)
    # Output: (400, 600, ‘Within Limits’)
    # Test Case 4 – “At Risk”
    # Input: (680, 10, 8, 6, 50, 8, 8, 0, 10, 0, 50, 50)
    # Output: (580, 780, ‘At Risk’)
    # Test Case 6 – “Already Exceeds”
    # Input: (680, 10, 12, 0, 50, 8, 10, 0, 10, 0, 50, 50)
    # Output: (800, 800, ‘At Risk’)
  end
end
