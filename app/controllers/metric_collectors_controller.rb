class MetricCollectorsController < ApplicationController
  def all_names
    names = KalibroProcessor.request("metric_collectors", {}, :get)

    respond_to do |format|
      format.html { render json: names }
      format.json { render json: names }
    end
  end

  def get
    metric_collector = KalibroProcessor.request("metric_collectors/#{params[:name]}/find", {}, :get)

    respond_to do |format|
      if metric_collector["error"].nil?
        # The client expects the supported metrics inside a Array, without code and the key on singular
        metric_collector["metric_collector"]["supported_metric"] = []
        metric_collector["metric_collector"]["supported_metrics"].each {|code, metric| metric_collector["metric_collector"]["supported_metric"] << metric}
        metric_collector["metric_collector"].delete("supported_metrics")

        format.json { render json: metric_collector["metric_collector"] }
      else
        format.json { render json: metric_collector, status: :unprocessable_entity }
      end
    end
  end
end
