require "test_helper"
require_relative "../support/authentication_test_helper"

# Proves that a user from one company can never read, modify, or delete
# another company's data, regardless of their own role. This is the
# single most important guarantee the whole multi-tenant design rests
# on, so these tests use an admin user (the highest-privileged role) on
# purpose: if even an admin from Company A is blocked from touching
# Company B's data, we know the block is coming from tenant scoping
# itself, not incidentally from a role check.
class TenantIsolationTest < ActionDispatch::IntegrationTest
  include AuthenticationTestHelper

  setup do
    @company_a = Company.create!(name: "Company A")
    @company_b = Company.create!(name: "Company B")

    @user_a = User.create!(
      company: @company_a, email_address: "a@example.com",
      password: "password123", role: :admin
    )
    @user_b = User.create!(
      company: @company_b, email_address: "b@example.com",
      password: "password123", role: :admin
    )

    @product_b = Product.create!(
      company: @company_b, sku: "B-SKU", name: "Company B Product",
      unit_price: 10, reorder_threshold: 0
    )
  end

  test "cannot view another company's product" do
    sign_in_as(@user_a, password: "password123")
    get product_url(@product_b)
    assert_response :not_found
  end

  test "cannot edit another company's product" do
    sign_in_as(@user_a, password: "password123")
    patch product_url(@product_b), params: { product: { name: "Hijacked" } }
    assert_response :not_found
    assert_equal "Company B Product", @product_b.reload.name
  end

  test "cannot delete another company's product" do
    sign_in_as(@user_a, password: "password123")
    assert_no_difference "Product.count" do
      delete product_url(@product_b)
    end
    assert_response :not_found
  end

  test "products index only shows own company's products" do
    own_product = Product.create!(
      company: @company_a, sku: "A-SKU", name: "Company A Product",
      unit_price: 5, reorder_threshold: 0
    )
    sign_in_as(@user_a, password: "password123")
    get products_url
    assert_response :success
    assert_match own_product.name, response.body
    assert_no_match(/Company B Product/, response.body)
  end
end
