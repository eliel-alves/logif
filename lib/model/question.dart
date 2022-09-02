// final List quiz = [
//   {
//     "question": "Pergunta 1?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 1
//   },
//   {
//     "question": "Pergunta 2?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 2
//   },
//   {
//     "question": "Pergunta 3?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 3
//   },
//   {
//     "question": "Pergunta 4?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 4
//   },
//   {
//     "question": "Pergunta 5?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 1
//   },
//   {
//     "question": "Pergunta 6?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 2
//   },
//   {
//     "question": "Pergunta 7?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 3
//   },
//   {
//     "question": "Pergunta 8?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 4
//   },
//   {
//     "question": "Pergunta 9?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 1
//   },
//   {
//     "question": "Pergunta 10?",
//     "answers": ["a", "b", "c", "d"],
//     "correct_answer": 2
//   }
// ];

class Question {
  String question;
  int correctAnswer;
  List<dynamic> answers;

  Question({required this.question, required this.correctAnswer, required this.answers});

  // factory Question.fromJson(Map<String, dynamic> json) {
  //   return Question(json['question'], json['correct_answer'], json['answers']);
  // }

  Map<String, dynamic> toJson() => {
        'question': question,
        'correct_answer': correctAnswer,
        'answers': answers
      };

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map["question"] as String,
      correctAnswer: map["correct_answer"] as int,
      answers: map["answers"] as List<dynamic>,
    );
  }
}
