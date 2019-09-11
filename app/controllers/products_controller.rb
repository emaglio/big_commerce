class ProductsController < ApplicationController
  before_action :authenticate_user

  def create
    product = Product::Create.call(params: params, user: user)
    if product.valid?
      redirect_to product_path(product)
    else
      flash[:error] = "Something went wrong #{product.errors.messages}"
      render :new
    end
  end

  def update
    product = Product::Update.call(params: params, user: user)
    if product.valid?
      redirect_to product_path(product)
    else
      flash[:error] = "Something went wrong #{product.errors.messages}"
      render :edit
    end
  end

  def delete
    product = Product::Delete.call(params: params, user: user)

    if product.persisted?
      flash[:error] = "Something went wrong #{product.errors.messages}"
    end

    redirect_to product_path(product)
  end
end
