class Admin::CouponsController < AdminController
  def index
    @coupons = Coupon.all
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(params[:coupon])
    if @coupon.save
      flash[:success] = "Coupon successfully created"
      redirect_to admin_coupons_path
    else
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    if @coupon.update_attributes(params[:coupon])
      flash[:success] = "Coupon successfully updated"
      redirect_to admin_coupons_path
    else
      render :edit
    end
  end
end
