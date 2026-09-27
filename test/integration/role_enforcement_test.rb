require "test_helper"
require_relative "../support/authentication_test_helper"

# Proves the viewer/staff/admin hierarchy is actually enforced, not just
# labeled. Each test targets one specific boundary from the role policy
# in README.md: viewers are read-only, staff can operate day-to-day but
# not delete, and only admins can delete or manage the team.
class RoleEnforcementTest < ActionDispatch::IntegrationTest
  include AuthenticationTestHelper

  setup do
    @company = Company.create!(name: "Acme Test Co")
    @viewer = User.create!(
      company: @company, email_address: "viewer@example.com",
      password: "password123", role: :viewer
    )
    @staff = User.create!(
      company: @company, email_address: "staff@example.com",
      password: "password123", role: :staff
    )
    @admin = User.create!(
      company: @company, email_address: "admin@example.com",
      password: "password123", role: :admin
    )
    @product = Product.create!(
      company: @company, sku: "SKU1", name: "Widget",
      unit_price: 10, reorder_threshold: 0
    )
  end

  test "viewer cannot create a product" do
    sign_in_as(@viewer, password: "password123")
    assert_no_difference "Product.count" do
      post products_url, params: { product: { sku: "NEW1", name: "New widget", unit_price: 5 } }
    end
    assert_redirected_to root_url
  end

  test "viewer cannot reach the new product form directly" do
    sign_in_as(@viewer, password: "password123")
    get new_product_url
    assert_redirected_to root_url
  end

  test "staff can create a product" do
    sign_in_as(@staff, password: "password123")
    assert_difference "Product.count", 1 do
      post products_url, params: { product: { sku: "NEW2", name: "New widget", unit_price: 5 } }
    end
  end

  test "staff cannot delete a product" do
    sign_in_as(@staff, password: "password123")
    assert_no_difference "Product.count" do
      delete product_url(@product)
    end
    assert_redirected_to root_url
  end

  test "admin can delete a product" do
    sign_in_as(@admin, password: "password123")
    assert_difference "Product.count", -1 do
      delete product_url(@product)
    end
  end

  test "viewer cannot reach the team page" do
    sign_in_as(@viewer, password: "password123")
    get invitations_url
    assert_redirected_to root_url
  end

  test "staff cannot reach the team page" do
    sign_in_as(@staff, password: "password123")
    get invitations_url
    assert_redirected_to root_url
  end

  test "admin can reach the team page" do
    sign_in_as(@admin, password: "password123")
    get invitations_url
    assert_response :success
  end
end
