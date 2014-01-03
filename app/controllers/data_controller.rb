class DataController < ApplicationController
  def toggle
    object = fetch_single params[:source]
    if object.class < TappableDataSource
      object.update_attribute(:green, !object.green)

      if (params[:callback])
        render :json => object, :callback => params[:callback]
      else
        render :json => object
      end
    else
      render nothing: true, status: :bad_request
    end
  end

  def all
    if params[:source]
      result = fetch_single(params[:source])
    else
      result = fetch_all
    end

    if (params[:callback])
      render :json => result, :callback => params[:callback]
    else
      render :json => result
    end
  end

  private

  def providers
    YAML.load(File.open('./config/enabled.yml'))
  end

  def class_for_provider(provider)
    Object.const_get(provider.classify)
  end

  def fetch_all
    result = {}
    providers.each {|provider|
      begin
        result[provider] = class_for_provider(provider).for_today
      rescue
      end
    }

    result
  end

  def fetch_single(provider)
    class_for_provider(provider).for_today
  end
end
