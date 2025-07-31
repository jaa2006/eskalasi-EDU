import 'package:flutter/material.dart';
import '../presentation/skill_detail/skill_detail.dart';
import '../presentation/student_registration/student_registration.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/quiz_interface/quiz_interface.dart';
import '../presentation/skill_tree_dashboard/skill_tree_dashboard.dart';
import '../presentation/progress_tracking/progress_tracking.dart';
import '../presentation/student_login/student_login.dart';
import '../presentation/enhanced_quiz_interface/enhanced_quiz_interface.dart';
import '../presentation/redesigned_skill_tree_dashboard/redesigned_skill_tree_dashboard.dart';
import '../presentation/student_profile/student_profile.dart';
import '../presentation/enhanced_onboarding_flow/enhanced_onboarding_flow.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String skillDetail = '/skill-detail';
  static const String studentRegistration = '/student-registration';
  static const String onboardingFlow = '/onboarding-flow';
  static const String quizInterface = '/quiz-interface';
  static const String skillTreeDashboard = '/skill-tree-dashboard';
  static const String progressTracking = '/progress-tracking';
  static const String studentLogin = '/student-login';
  static const String enhancedQuizInterface = '/enhanced-quiz-interface';
  static const String redesignedSkillTreeDashboard =
      '/redesigned-skill-tree-dashboard';
  static const String studentProfile = '/student-profile';
  static const String enhancedOnboardingFlow = '/enhanced-onboarding-flow';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const EnhancedOnboardingFlow(),
    skillDetail: (context) => const SkillDetail(),
    studentRegistration: (context) => const StudentRegistration(),
    onboardingFlow: (context) => const OnboardingFlow(),
    quizInterface: (context) => const QuizInterface(),
    skillTreeDashboard: (context) => const SkillTreeDashboard(),
    progressTracking: (context) => const ProgressTracking(),
    studentLogin: (context) => const StudentLogin(),
    enhancedQuizInterface: (context) => const EnhancedQuizInterface(),
    redesignedSkillTreeDashboard: (context) =>
        const RedesignedSkillTreeDashboard(),
    studentProfile: (context) => const StudentProfile(),
    enhancedOnboardingFlow: (context) => const EnhancedOnboardingFlow(),
    // TODO: Add your other routes here
  };
}
