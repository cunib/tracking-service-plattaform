class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @products = @business.products
    @q = @products.search(session_params)
    @q.sorts = ["created_at desc"]
    @products = @q.result.page(page_param)
    respond_with(@products, location: [@business, :products])
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    @product.business = @business
    @product.save
    respond_with(@product, location: [@business, :products])
  end

  def update
    @product.update(product_params)
    respond_with(@product, location: [@business, :product])
  end

  def destroy
    @product.destroy
    respond_with(@product, location: [@business, :products])
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end
end
