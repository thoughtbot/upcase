module ResultsHelper
  def saved_class_for(current_user, question)
    if question.saved_for_review?(current_user)
      "kept-flashcard"
    else
      ""
    end
  end
end
