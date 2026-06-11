class AiReadinessOption {
  const AiReadinessOption({required this.label, required this.score});
  final String label;
  final int score;
}

class AiReadinessQuestion {
  const AiReadinessQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
  final String id;
  final String question;
  final List<AiReadinessOption> options;
}

class AppConstants {
  AppConstants._();

  // App
  static const String appName = 'SwipeMatch';
  static const int dailyDeckSize = 15;
  static const int deckRefreshHour = 8;
  static const int pushNotificationHour = 18;
  static const int cardExpiryHours = 24;
  static const int expiryWarningHours = 2;
  static const int momentumSwipeCount = 5;

  // Onboarding
  static const int minSkillsRequired = 3;
  static const int maxCultureTags = 5;

  // Profile completion weights (must sum to 100)
  static const int completionAvatar = 15;
  static const int completionBio = 10;
  static const int completionSkills = 20;
  static const int completionLocation = 15;
  static const int completionWorkStyle = 10;
  static const int completionCultureTags = 10;
  static const int completionExperience = 10;
  static const int completionPassiveMode = 10;

  static const int passiveModeDeckSize = 5;

  // Strings — core
  static const String itsAMatch = "It's a Match!";
  static const String keepSwiping = "Keep Swiping";
  static const String sendMessage = "Send a Message";
  static const String deckEmptyTitle = "You've met everyone today";
  static const String deckEmptySubtitle = "New people arrive at 8am";
  static const String missedMatchesMessage =
      "You missed 3 matches last week because your deck expired.";
  static const String momentumMessage = "You're on a roll!";
  static const String streakGraceMessage =
      "Recover your streak before midnight!";

  // Notification strings
  static const String notifDeckReady = "Your fresh deck is ready";
  static const String notifDeckReadyBody = "15 new opportunities waiting";
  static const String notifEmployerBookmark =
      "A company is interested in your profile";
  static const String notifWeeklyReview = "Your week in review";
  static const String notifExpiringCards = "job cards expire tonight";

  // Welcome screen
  static const String welcomeSkip = 'Skip intro';
  static const String welcomeNext = 'Next';
  static const String welcomeGetStarted = 'Get Started';

  // Onboarding
  static const String onboardingSkipLabel = 'Skip setup — explore now';
  static const String onboardingAiReadinessTitle = 'Your growth score';
  static const String onboardingAiReadinessSubtitle =
      'Every field is changing. See where you stand and how to grow faster.';

  // Community
  static const String postsTabLabel = 'Posts';
  static const String postsEmptyTitle = 'Start the conversation';
  static const String postsEmptySubtitle =
      'Share a win, ask for advice, or just say something honest about work.';
  static const String createPostTitle = 'Share with the community';
  static const String postTitleHint = 'Give it a compelling title';
  static const String postContentHint =
      'What do you want to share? Be honest — that\'s what makes it valuable.';
  static const String postAddPhoto = 'Photo';
  static const String postAddVideo = 'Video';
  static const String postMediaUploading = 'Uploading media…';
  static const String commentsTitle = 'Comments';
  static const String commentHint = 'Add a thoughtful comment…';
  static const String commentsEmptyTitle = 'No comments yet';
  static const String commentsEmptySubtitle =
      'Be the first to respond — thoughtful replies get noticed.';
  static const String trendingLabel = 'Trending';
  static const int trendingLikeThreshold = 5;
  static const String savedEmptyTitle = 'No saved posts yet';
  static const String savedEmptySubtitle =
      'Tap the bookmark on any post to save it here for later.';

  // Work styles
  static const String remote = 'remote';
  static const String hybrid = 'hybrid';
  static const String onSite = 'on_site';

  // Job search timelines
  static const String timeline1Month = '1_month';
  static const String timeline3Months = '3_months';
  static const String timeline6Months = '6_months';
  static const String timelineExploring = 'exploring';

  // Open-networking personas — single-select in onboarding. The app is for
  // everyone (students, founders, creators, politicians…), not just job seekers.
  static const List<String> personas = [
    'Student',
    'Founder',
    'Creator',
    'Professional',
    'Investor',
    'Politician',
    'Researcher',
    'Other',
  ];

  // Connection intents — DB value → display label. 'random' drives the
  // serendipity / "surprise me" matching path.
  static const Map<String, String> connectionIntents = {
    'mentorship': 'Mentorship',
    'collaborators': 'Collaborators',
    'investors': 'Investors',
    'hiring': 'Hiring / Jobs',
    'friends': 'Friends',
    'knowledge': 'Knowledge share',
    'random': 'Surprise me',
  };

  // Career streams — all fields, not just tech
  static const List<String> roleCategories = [
    // Technology
    'Software Engineering',
    'Frontend Development',
    'Backend Development',
    'Mobile Development',
    'DevOps & Cloud',
    'Cybersecurity',
    'Data Science',
    'Machine Learning / AI',
    'QA & Testing',
    'Systems Architecture',
    // Design & Creative
    'UX / Product Design',
    'Graphic Design',
    'Architecture',
    'Film & Media Production',
    'Creative Writing',
    // Business
    'Product Management',
    'Marketing',
    'Sales',
    'Finance & Accounting',
    'Operations',
    'Business Strategy',
    'Human Resources',
    'Legal & Compliance',
    // Science & Research
    'Scientific Research',
    'Biotech & Pharma',
    'Environmental Science',
    'Physics & Engineering',
    'Chemistry',
    // Healthcare
    'Medicine & Clinical',
    'Nursing & Allied Health',
    'Mental Health',
    'Public Health',
    'Veterinary',
    // Education & Social
    'Education & Teaching',
    'Academic Research',
    'Social Work',
    'Nonprofit & NGO',
    'Government & Policy',
    // Other
    'Entrepreneurship',
    'Consulting',
    'Other',
  ];

  // Culture tags
  static const List<String> cultureTags = [
    'Fast-paced',
    'Work-life balance',
    'Startup energy',
    'Mission-driven',
    'Fully async',
    'Strong mentorship',
    'Flat hierarchy',
    'High growth',
    'Research-focused',
    'Collaborative',
    'Global team',
    'Impact-driven',
  ];

  // Popular skills — covers all career domains
  static const List<String> popularSkills = [
    // Tech
    'Flutter', 'React', 'Python', 'TypeScript', 'Swift', 'Kotlin',
    'Node.js', 'Go', 'SQL', 'AWS', 'Docker', 'Kubernetes',
    // Data & AI
    'Machine Learning', 'Data Analysis', 'TensorFlow', 'Power BI',
    // Design
    'Figma', 'Adobe Creative Suite', 'Prototyping', 'User Research',
    // Business
    'Product Management', 'Agile / Scrum', 'Financial Modeling',
    'Marketing Strategy', 'CRM', 'Salesforce',
    // Science & Health
    'Research Methodology', 'Clinical Trials', 'Statistical Analysis',
    'SPSS / R', 'Lab Techniques',
    // Soft skills
    'Public Speaking', 'Technical Writing', 'Project Management',
  ];

  // Post types — community-first framing
  static const List<String> postTypes = [
    'honest',
    'win',
    'ask',
    'research',
    'achievement',
    'collaboration',
    'insight',
    'essay',
  ];

  static const Map<String, String> postTypeLabels = {
    'honest': 'Real Talk',
    'win': 'Small Win',
    'ask': 'Need Advice',
    'research': 'Research',
    'achievement': 'Achievement',
    'collaboration': 'Collab Call',
    'insight': 'Insight',
    'essay': 'Essay',
  };

  // Swipe directions
  static const String swipeRight = 'right';
  static const String swipeLeft = 'left';
  static const String superLike = 'super';

  // Match statuses
  static const String statusNewMatch = 'new_match';
  static const String statusContacted = 'contacted';
  static const String statusInterview = 'interview_scheduled';
  static const String statusOffer = 'offer_sent';
  static const String statusHired = 'hired';

  // AI Readiness — scored 0–100 (5 questions × 20pts max)
  static const List<AiReadinessQuestion> aiReadinessQuestions = [
    AiReadinessQuestion(
      id: 'q1',
      question: 'How often do you use AI tools (ChatGPT, Copilot, Claude, etc.)?',
      options: [
        AiReadinessOption(label: 'Never used them', score: 0),
        AiReadinessOption(label: 'Tried a couple of times', score: 5),
        AiReadinessOption(label: 'A few times a week', score: 12),
        AiReadinessOption(label: 'Daily — part of my workflow', score: 20),
      ],
    ),
    AiReadinessQuestion(
      id: 'q2',
      question: 'Can you use AI to automate or speed up parts of your work?',
      options: [
        AiReadinessOption(label: "Not yet — haven't tried", score: 0),
        AiReadinessOption(label: "I've experimented a little", score: 5),
        AiReadinessOption(label: 'I automate several tasks with it', score: 14),
        AiReadinessOption(label: "I've built custom AI workflows", score: 20),
      ],
    ),
    AiReadinessQuestion(
      id: 'q3',
      question: 'Have you learned about AI through courses, reading, or projects this year?',
      options: [
        AiReadinessOption(label: 'Nothing yet', score: 0),
        AiReadinessOption(label: 'Watched a few videos', score: 5),
        AiReadinessOption(label: 'Completed a structured course', score: 12),
        AiReadinessOption(label: 'Multiple courses and built something', score: 20),
      ],
    ),
    AiReadinessQuestion(
      id: 'q4',
      question: 'How much will AI change your field over the next 3 years?',
      options: [
        AiReadinessOption(label: 'Not much — my field is AI-resistant', score: 0),
        AiReadinessOption(label: 'Minor changes at the edges', score: 5),
        AiReadinessOption(label: 'Significant shifts in how work is done', score: 12),
        AiReadinessOption(label: 'Fundamental transformation', score: 20),
      ],
    ),
    AiReadinessQuestion(
      id: 'q5',
      question: 'How prepared do you feel to work alongside AI tools right now?',
      options: [
        AiReadinessOption(label: 'Not prepared at all', score: 0),
        AiReadinessOption(label: 'Somewhat — still learning', score: 5),
        AiReadinessOption(label: 'Moderately prepared', score: 12),
        AiReadinessOption(label: 'Very prepared — already doing it', score: 20),
      ],
    ),
  ];

  static String aiReadinessLabel(int score) {
    if (score >= 76) return 'AI Native';
    if (score >= 51) return 'AI Fluent';
    if (score >= 26) return 'AI Explorer';
    return 'AI Aware';
  }

  static String aiReadinessDescription(int score) {
    if (score >= 76) {
      return 'You work with AI as a natural part of your daily practice.';
    }
    if (score >= 51) {
      return 'You use AI tools regularly and understand their impact on your field.';
    }
    if (score >= 26) {
      return "You're exploring AI. Keep going — the gap between Explorer and Fluent closes fast.";
    }
    return "You're just getting started. Now is the best time to begin.";
  }
}
