import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/quiz_answer_option.dart';
import './widgets/quiz_feedback_modal.dart';
import './widgets/quiz_progress_bar.dart';
import './widgets/quiz_question_card.dart';
import './widgets/quiz_result_summary.dart';

class QuizInterface extends StatefulWidget {
  const QuizInterface({super.key});

  @override
  State<QuizInterface> createState() => _QuizInterfaceState();
}

class _QuizInterfaceState extends State<QuizInterface>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _showFeedback = false;
  bool _quizCompleted = false;
  List<int> _userAnswers = [];
  List<bool> _answerResults = [];

  // Mock quiz data
  final List<Map<String, dynamic>> _quizData = [
    {
      "id": 1,
      "question": "Apa kepanjangan dari TCP dalam protokol jaringan?",
      "imageUrl": null,
      "options": [
        "Transfer Control Protocol",
        "Transmission Control Protocol",
        "Transport Communication Protocol",
        "Technical Control Protocol"
      ],
      "correctAnswer": 1,
      "explanation":
          "TCP (Transmission Control Protocol) adalah protokol yang menyediakan layanan pengiriman data yang handal dan berurutan dalam jaringan komputer."
    },
    {
      "id": 2,
      "question": "Berapa jumlah bit dalam alamat IPv4?",
      "imageUrl":
          "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "options": ["16 bit", "24 bit", "32 bit", "64 bit"],
      "correctAnswer": 2,
      "explanation":
          "Alamat IPv4 terdiri dari 32 bit yang dibagi menjadi 4 oktet, masing-masing berisi 8 bit. Contoh: 192.168.1.1"
    },
    {
      "id": 3,
      "question": "Manakah yang merupakan perangkat Layer 2 dalam model OSI?",
      "imageUrl": null,
      "options": ["Router", "Hub", "Switch", "Gateway"],
      "correctAnswer": 2,
      "explanation":
          "Switch beroperasi pada Layer 2 (Data Link Layer) dan menggunakan MAC address untuk meneruskan frame data antar perangkat dalam jaringan lokal."
    },
    {
      "id": 4,
      "question": "Apa fungsi utama dari subnet mask?",
      "imageUrl":
          "https://images.unsplash.com/photo-1544197150-b99a580bb7a8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "options": [
        "Mengenkripsi data jaringan",
        "Membagi jaringan menjadi subnet yang lebih kecil",
        "Mengatur kecepatan transfer data",
        "Menyimpan alamat MAC perangkat"
      ],
      "correctAnswer": 1,
      "explanation":
          "Subnet mask digunakan untuk membagi jaringan IP menjadi subnet yang lebih kecil dan menentukan bagian network dan host dari alamat IP."
    },
    {
      "id": 5,
      "question": "Port berapa yang digunakan oleh protokol HTTP?",
      "imageUrl": null,
      "options": ["Port 21", "Port 25", "Port 80", "Port 443"],
      "correctAnswer": 2,
      "explanation":
          "HTTP (HyperText Transfer Protocol) menggunakan port 80 sebagai port default untuk komunikasi web yang tidak terenkripsi."
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _userAnswers = List.filled(_quizData.length, -1);
    _answerResults = List.filled(_quizData.length, false);
  }

  void _initializeControllers() {
    _pageController = PageController();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _selectAnswer(int answerIndex) {
    if (_selectedAnswerIndex != null) return;

    setState(() {
      _selectedAnswerIndex = answerIndex;
    });

    // Show feedback after a brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final isCorrect =
            answerIndex == _quizData[_currentQuestionIndex]["correctAnswer"];
        _userAnswers[_currentQuestionIndex] = answerIndex;
        _answerResults[_currentQuestionIndex] = isCorrect;

        setState(() {
          _showFeedback = true;
        });
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _showFeedback = false;
      _selectedAnswerIndex = null;
    });

    if (_currentQuestionIndex < _quizData.length - 1) {
      _slideController.reset();
      _slideController.forward();

      setState(() {
        _currentQuestionIndex++;
      });

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Quiz completed
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _retakeQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswerIndex = null;
      _showFeedback = false;
      _quizCompleted = false;
      _userAnswers = List.filled(_quizData.length, -1);
      _answerResults = List.filled(_quizData.length, false);
    });

    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _continueLearning() {
    Navigator.pushReplacementNamed(context, '/skill-detail');
  }

  void _exitQuiz() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Keluar dari Kuis?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Progres kuis Anda akan hilang jika keluar sekarang. Apakah Anda yakin?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
                foregroundColor: AppTheme.backgroundWhite,
              ),
              child: Text(
                'Keluar',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.backgroundWhite,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int get _correctAnswersCount {
    return _answerResults.where((result) => result).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: _quizCompleted
          ? null
          : AppBar(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: AppTheme.backgroundWhite,
              elevation: 2,
              leading: IconButton(
                onPressed: _exitQuiz,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.backgroundWhite,
                  size: 24,
                ),
              ),
              title: Text(
                'Kuis Jaringan Komputer',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.backgroundWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 4.w),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.accentYellow.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accentYellow,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${_currentQuestionIndex + 1}/${_quizData.length}',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
      body: SafeArea(
        child: _quizCompleted ? _buildResultScreen() : _buildQuizScreen(),
      ),
    );
  }

  Widget _buildQuizScreen() {
    return Stack(
      children: [
        Column(
          children: [
            // Progress bar
            QuizProgressBar(
              currentQuestion: _currentQuestionIndex + 1,
              totalQuestions: _quizData.length,
              showTimer: false,
            ),

            // Quiz content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _quizData.length,
                itemBuilder: (context, index) {
                  return SlideTransition(
                    position: _slideAnimation,
                    child: _buildQuestionPage(index),
                  );
                },
              ),
            ),

            // Next button
            if (_selectedAnswerIndex != null && !_showFeedback)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: AppTheme.backgroundWhite,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentQuestionIndex < _quizData.length - 1
                            ? 'Pertanyaan Selanjutnya'
                            : 'Selesaikan Kuis',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.backgroundWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: _currentQuestionIndex < _quizData.length - 1
                            ? 'arrow_forward'
                            : 'check',
                        color: AppTheme.backgroundWhite,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        // Feedback modal
        if (_showFeedback)
          QuizFeedbackModal(
            isCorrect: _answerResults[_currentQuestionIndex],
            explanation: _quizData[_currentQuestionIndex]["explanation"],
            onContinue: _nextQuestion,
          ),
      ],
    );
  }

  Widget _buildQuestionPage(int questionIndex) {
    final questionData = _quizData[questionIndex];
    final options = (questionData["options"] as List).cast<String>();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Question card
          QuizQuestionCard(
            question: questionData["question"],
            imageUrl: questionData["imageUrl"],
            questionNumber: questionIndex + 1,
            totalQuestions: _quizData.length,
          ),

          SizedBox(height: 2.h),

          // Answer options
          ...List.generate(options.length, (optionIndex) {
            return QuizAnswerOption(
              optionText: options[optionIndex],
              optionLabel: String.fromCharCode(65 + optionIndex), // A, B, C, D
              isSelected: _selectedAnswerIndex == optionIndex,
              isCorrect: optionIndex == questionData["correctAnswer"],
              showResult: false,
              onTap: () => _selectAnswer(optionIndex),
            );
          }),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    return SingleChildScrollView(
      child: QuizResultSummary(
        correctAnswers: _correctAnswersCount,
        totalQuestions: _quizData.length,
        skillTitle: 'Jaringan Komputer - Dasar',
        onRetakeQuiz: _retakeQuiz,
        onContinueLearning: _continueLearning,
      ),
    );
  }
}
