module QuestionsHelper
  def visualize_votes_for(option)
    content_tag :div, class: 'progress' do
      content_tag :div, class: 'progress-bar',
                  style: "width: #{option.question.normalized_votes_for(option)}%" do
        "#{option.votes.count}"
      end
    end
  end
end
