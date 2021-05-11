class GraphPresenter

    attr_reader :query_object
    attr_reader :x_bars


    def initialize(query_object,x_bars)
       @query_object = query_object 
       @x_bars = x_bars
    end

    def polar_graph
        summary = {}
        x_bars.each_with_index do |bar,index|
            result_object = query_object.call(bar)
            summary[bar] = result_object.with_all_dimensions
        end
        summary
    end

    def datasets
        # raise
        datasets = []
        gauge_dials =[]
        x_bars.each_with_index do |bar,index|
            result_object = query_object.call(bar)
            summary = result_object.with_all_dimensions
            datasets << {
				data: summary.values.map{ |v| v.round(2) },
				label: bar.humanize.capitalize,
				backgroundColor: colors[index]
			}
            gauge_dials << {
                

                # Fusion Charts
                
                # value: result_object.scoped_result[:avg],
                # tooltext: "<b>#{bar.humanize}:</b> #{result_object.scoped_result[:avg]}"
                
                # High Charts

                name: bar.humanize,
                data: [result_object.scoped_result[:avg]],
                dataLabels: {
                    enabled: false,
                },
                dial: {
                    backgroundColor: colors[index]
                }
            }
        end
        {bar: datasets, gauge_dials: gauge_dials}
    end

    def bar_graph_object(label,color,data)
        result_object = query_object.call(x_bar)
        summary = result_object.with_all_dimensions
        {
            data: summary.values,
			label: label,
			backgroundColor: color

        }
    end

    private

    def colors
        ['#ecace9','#bdbcbc','#bfedf1','#e57e84','#f8dbba']
    end

    

    # def average_with_data
    #     @query_result
	# 	if @query_result.empty?
	# 		avg = 0
	# 	else
	# 		avg = @query_result.values.sum/@query_result.size.to_f
	# 	end
	# 	{avg: avg, data:@query_result}
    # end

    # def 

    # def gauge_graph_data
    #     average_with_data
    #     gauge_dials = {}
    #     gauge_dials << {
	# 			value: average_with_data[:avg],
	# 			tooltext: "<b>#{u.humanize}:</b> #{average_with_data[:avg]}"
	# 	}
    # end
end