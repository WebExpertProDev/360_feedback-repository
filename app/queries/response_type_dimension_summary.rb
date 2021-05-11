class ResponseTypeDimensionSummary

    attr_reader :relation
    attr_reader :questionnaire
    attr_reader :params
    attr_reader :scoped_result

    
    def initialize(params, relation = LeadershipSurvey.joins(:responses))
        @relation = relation
        @params = params
        @questionnaire = params[:questionnaire]
    end

    def call(response_user_type)
        # p "hello"
        scoped_result = nil
        scoped_result = for_survey(params[:survey_id],relation)
        scoped_result = submissions(scoped_result)
        scoped_result = with_statement_type_user_type_questionnaire(params[:statement_type], response_user_type, questionnaire.id,scoped_result)
        scoped_result = dimension_wise_average(scoped_result)
        @scoped_result = average_with_data(scoped_result)
        self

    end

    def for_survey(survey_id,scoped_result)
        scoped_result.find(survey_id)
    end

    def submissions(scoped_result)
        scoped_result.submissions
    end

    def with_statement_type_user_type_questionnaire(statement_type,response_user_type,questionnaire_id,scoped_result)
        scoped_result
            .joins(:question_statement,question: [:dimension,:questionnaire])
            .where(
                "question_statements.statement_type"=> statement_type,"responses.user_type" => response_user_type,
                "questionnaires.id"=> questionnaire_id
            )
    end

    def dimension_wise_average(scoped_result)
        scoped_result
            .group("questions.dimension_id")
            .average(:scaled_score)
    end

    def average_with_data(scoped_result)
		if scoped_result.empty?
			avg = 0
		else
			avg = scoped_result.values.sum/scoped_result.size.to_f
		end
		{avg: avg.round(2), data: scoped_result}
    end

    def with_all_dimensions
        dev_data_summary_other = {}
        questionnaire.dimensions.each do |dimension|
			dev_data_summary_other[dimension.name] = scoped_result[:data][dimension.id].nil? ? 0: scoped_result[:data][dimension.id]
        end
        # dev_data_summary_other[:avg] = 
        dev_data_summary_other
    end
end