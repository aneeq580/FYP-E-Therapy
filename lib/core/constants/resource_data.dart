import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/resource_model.dart';

class ResourceData {
  static final List<ResourceModel> articles = [
    const ResourceModel(
      id: 'a1',
      title: 'Understanding Anxiety: What\'s Happening in Your Brain',
      description: 'Anxiety is your brain\'s alarm system. The amygdala triggers a \'fight or flight\' response, flooding your body with...',
      content: 'Anxiety is a natural response to stress, but when it becomes chronic, it can interfere with daily life. Common symptoms include restlessness, rapid heartbeat, and difficulty concentrating. Understanding your triggers is the first step toward management. Cognitive Behavioral Therapy (CBT) and mindfulness are proven techniques to help reduce anxiety levels over time.',
      category: ResourceCategory.articles,
      icon: FontAwesomeIcons.brain,
      tag: 'Anxiety',
      readTime: '5 min read',
      rating: 4.8,
      color: Color(0xFFE3F2FD), // Very Light Blue
      tagColor: Color(0xFFBBDEFB), // Light Blue
    ),
    const ResourceModel(
      id: 'a2',
      title: 'The Science of Sleep and Mental Health',
      description: 'Sleep and mental health are deeply connected. During sleep, your brain consolidates memories, processes...',
      content: 'Sleep is not just a time for the body to rest; it is essential for brain function and emotional regulation. Poor sleep can exacerbate symptoms of depression and anxiety. Establishing a consistent sleep schedule, limiting screen time before bed, and creating a relaxing environment can significantly improve sleep quality and overall well-being.',
      category: ResourceCategory.articles,
      icon: FontAwesomeIcons.moon,
      tag: 'Wellness',
      readTime: '7 min read',
      rating: 4.9,
      color: Color(0xFFF3E5F5), // Very Light Purple
      tagColor: Color(0xFFE1BEE7), // Light Purple
    ),
    const ResourceModel(
      id: 'a3',
      title: 'How Journaling Can Transform Your Mental Health',
      description: 'Writing about your thoughts and feelings helps externalize internal chaos. Studies show journaling reduces symptoms...',
      content: 'Stress is an unavoidable part of life, but how we respond to it matters. Healthy coping mechanisms include regular exercise, maintaining a balanced diet, and staying connected with loved ones. It is also important to set boundaries and learn to say no when feeling overwhelmed. Practice gratitude and focus on what you can control.',
      category: ResourceCategory.articles,
      icon: FontAwesomeIcons.bookOpen,
      tag: 'Self-Care',
      readTime: '4 min read',
      rating: 4.7,
      color: Color(0xFFFCE4EC), // Very Light Pink
      tagColor: Color(0xFFF8BBD0), // Light Pink
    ),
    const ResourceModel(
      id: 'a4',
      title: 'Building Resilience After Trauma',
      description: 'Resilience isn\'t about being tough — it\'s about bouncing back. After trauma, your nervous system is on high alert...',
      content: 'Building resilience is a process of adapting well in the face of adversity, trauma, tragedy, threats, or significant sources of stress. It involves developing positive relationships, making every day meaningful, and learning from experience. You can build resilience at any age.',
      category: ResourceCategory.articles,
      icon: FontAwesomeIcons.shieldHalved,
      tag: 'Trauma',
      readTime: '8 min read',
      rating: 4.6,
      color: Color(0xFFFFF9C4), // Very Light Yellow
      tagColor: Color(0xFFFFF176), // Light Yellow/Amber
    ),
    const ResourceModel(
      id: 'a5',
      title: 'The Power of Setting Healthy Boundaries',
      description: 'Boundaries are not walls — they are bridges that define how you want to be treated. Without boundaries, resentment...',
      content: 'Setting boundaries is an essential part of self-care. It involves identifying your needs and communicating them clearly to others. Boundaries help you maintain your integrity and prevent burnout in both personal and professional relationships.',
      category: ResourceCategory.articles,
      icon: FontAwesomeIcons.arrowsLeftRight,
      tag: 'Relationships',
      readTime: '6 min read',
      rating: 4.8,
      color: Color(0xFFE0F7FA), // Very Light Cyan
      tagColor: Color(0xFFB2EBF2), // Light Cyan
    ),
    const ResourceModel(
      id: 'a6',
      title: 'Mindful Eating and Emotional Well-being',
      description: 'Food and mood are closely linked. High-sugar diets can increase anxiety and depression. Foods rich in omega-3s...',
      content: 'Mindful eating is a technique that helps you gain control over your eating habits. It has been shown to promote weight loss, reduce binge eating, and help you feel better overall. Pay attention to the colors, smells, textures, and flavors of your food.',
      category: ResourceCategory.articles,
      icon: FontAwesomeIcons.bowlFood,
      tag: 'Wellness',
      readTime: '5 min read',
      rating: 4.5,
      color: Color(0xFFE8F5E9), // Very Light Green
      tagColor: Color(0xFFC8E6C9), // Light Green
    ),
  ];

  static final List<ResourceModel> breathingExercises = [
    const ResourceModel(
      id: 'b1',
      title: '4-7-8 Breathing',
      description: 'Calm your nervous system in minutes',
      content: 'A rhythmic breathing pattern for deep relaxation.',
      category: ResourceCategory.breathing,
      icon: FontAwesomeIcons.wind,
      duration: Duration(minutes: 5),
      difficulty: 'Beginner',
      benefits: 'Reduces anxiety, lowers heart rate, promotes sleep.',
      topBorderColor: Color(0xFF4FC3F7), // Blue
      steps: [
        'Sit comfortably with your back straight.',
        'Exhale completely through your mouth.',
        'Close your mouth and inhale quietly through your nose for 4 counts.',
        'Hold your breath for 7 counts.',
        'Exhale completely through your mouth for 8 counts.',
        'Repeat this cycle 3–4 times.',
      ],
    ),
    const ResourceModel(
      id: 'b2',
      title: 'Box Breathing',
      description: 'Used by Navy SEALs for stress control',
      content: 'Calm your nervous system with this simple technique.',
      category: ResourceCategory.breathing,
      icon: FontAwesomeIcons.square,
      duration: Duration(minutes: 4),
      difficulty: 'Beginner',
      benefits: 'Improves focus, reduces stress, regulates the nervous system.',
      topBorderColor: Color(0xFF66BB6A), // Green
      steps: [
        'Inhale for 4 seconds.',
        'Hold for 4 seconds.',
        'Exhale for 4 seconds.',
        'Hold for 4 seconds.',
        'Repeat the cycle for several minutes.',
      ],
    ),
    const ResourceModel(
      id: 'b3',
      title: 'Diaphragmatic Breathing',
      description: 'Deep belly breathing for relaxation',
      content: 'Learn to breathe using your diaphragm for maximum oxygen intake.',
      category: ResourceCategory.breathing,
      icon: FontAwesomeIcons.lungs,
      duration: Duration(minutes: 10),
      difficulty: 'Beginner',
      benefits: 'Reduces cortisol, improves oxygen exchange, eases tension.',
      topBorderColor: Color(0xFFCE93D8), // Purple
      steps: [
        'Lie on your back with your knees slightly bent.',
        'Place one hand on your upper chest and the other below your rib cage.',
        'Inhale slowly through your nose so that your stomach moves out.',
        'The hand on your chest should remain as still as possible.',
        'Tighten your stomach muscles as you exhale through pursed lips.',
      ],
    ),
    const ResourceModel(
      id: 'b4',
      title: 'Alternate Nostril Breathing',
      description: 'Ancient yogic technique for balance',
      content: 'Nadi Shodhana is a powerful breathing practice for clarity.',
      category: ResourceCategory.breathing,
      icon: FontAwesomeIcons.repeat,
      duration: Duration(minutes: 7),
      difficulty: 'Intermediate',
      benefits: 'Balances left and right brain hemispheres, promotes calm and clarity.',
      topBorderColor: Color(0xFFF06292), // Pink
      steps: [
        'Sit in a comfortable position with your legs crossed.',
        'Close your right nostril with your right thumb.',
        'Inhale through your left nostril.',
        'Close your left nostril with your ring finger.',
        'Open and exhale through your right nostril.',
        'Inhale through your right, then switch to exhale through left.',
      ],
    ),
  ];

  static final List<ResourceModel> meditations = [
    const ResourceModel(
      id: 'm1',
      title: 'Morning Mindfulness',
      description: 'Start your day with intention and calm',
      content: '"Close your eyes and take three deep breaths. As you breathe in, imagine warm golden light filling your body. As you breathe out, release any tension from yesterday. Set an intention for today — one word that captures how you want to feel. Hold that word gently as you breathe. You are safe, you are present, and today is a new beginning."',
      category: ResourceCategory.meditation,
      icon: FontAwesomeIcons.sun,
      duration: Duration(minutes: 10),
      tag: 'Guided',
      color: Color(0xFFFFFDE7), // Light Yellow
      topBorderColor: Color(0xFFFFD54F), // Amber/Yellow
    ),
    const ResourceModel(
      id: 'm2',
      title: 'Body Scan Relaxation',
      description: 'Release physical tension from head to toe',
      content: 'A deep relaxation technique that involves mentally scanning your body for tension and consciously releasing it. Perfect for unwinding after a long day or before sleep.',
      category: ResourceCategory.meditation,
      icon: FontAwesomeIcons.leaf,
      duration: Duration(minutes: 15),
      tag: 'Relaxation',
      color: Color(0xFFF1F8E9), // Light Green
      topBorderColor: Color(0xFF81C784), // Green
    ),
    const ResourceModel(
      id: 'm3',
      title: 'Loving-Kindness Meditation',
      description: 'Cultivate compassion for yourself and others',
      content: 'Also known as Metta meditation, this practice involves repeating phrases of goodwill and kindness toward yourself, loved ones, and even difficult people in your life.',
      category: ResourceCategory.meditation,
      icon: FontAwesomeIcons.heartPulse,
      duration: Duration(minutes: 12),
      tag: 'Compassion',
      color: Color(0xFFE0F2F1), // Light Teal/Mint
      topBorderColor: Color(0xFF4DB6AC), // Teal
    ),
    const ResourceModel(
      id: 'm4',
      title: 'Anxiety Relief Meditation',
      description: 'Ground yourself during anxious moments',
      content: 'Focus on grounding techniques like the 5-4-3-2-1 method or simple breath awareness to bring your mind back to the present moment and reduce feelings of overwhelm.',
      category: ResourceCategory.meditation,
      icon: FontAwesomeIcons.cloudRain,
      duration: Duration(minutes: 8),
      tag: 'Anxiety',
      color: Color(0xFFE3F2FD), // Light Blue
      topBorderColor: Color(0xFF64B5F6), // Blue
    ),
    const ResourceModel(
      id: 'm5',
      title: 'Sleep Meditation',
      description: 'Gently drift into peaceful sleep',
      content: 'Using soft visualizations and progressive muscle relaxation, this meditation helps lower your heart rate and prepare your mind for a night of deep, restful sleep.',
      category: ResourceCategory.meditation,
      icon: FontAwesomeIcons.moon,
      duration: Duration(minutes: 20),
      tag: 'Sleep',
      color: Color(0xFFEDE7F6), // Light Lavender
      topBorderColor: Color(0xFF9575CD), // Purple
    ),
  ];

  static final List<ResourceModel> selfHelpTips = [
    const ResourceModel(
      id: 's1',
      title: 'Daily Habits',
      description: 'Small changes for a better day',
      content: 'Consistent habits are the foundation of mental well-being.',
      category: ResourceCategory.selfHelp,
      icon: FontAwesomeIcons.sun,
      color: Color(0xFFFFFDE7),
      topBorderColor: Color(0xFFFFD54F),
      steps: [
        'Wake up at the same time every day to regulate your body clock.',
        'Drink a glass of water first thing in the morning.',
        'Step outside for at least 10 minutes of natural light daily.',
        'Limit caffeine after 2pm to protect sleep quality.',
        'Spend 5 minutes each night reflecting on 3 good things that happened.',
      ],
    ),
    const ResourceModel(
      id: 's2',
      title: 'Managing Anxiety',
      description: 'Practical tools for calm',
      content: 'Techniques to help you stay grounded.',
      category: ResourceCategory.selfHelp,
      icon: FontAwesomeIcons.cloudRain,
      color: Color(0xFFE3F2FD),
      topBorderColor: Color(0xFF64B5F6),
      steps: [
        'Challenge anxious thoughts: ask "Is this thought a fact or a fear?"',
        'Use the 5-4-3-2-1 grounding technique when overwhelmed.',
        'Limit news and social media consumption to 30 minutes a day.',
        'Schedule a "worry time" — 15 minutes to write down your concerns.',
        'Progressive muscle relaxation: tense and release each muscle group.',
      ],
    ),
    const ResourceModel(
      id: 's3',
      title: 'Boosting Mood',
      description: 'Elevate your emotional state',
      content: 'Simple actions to improve your outlook.',
      category: ResourceCategory.selfHelp,
      icon: FontAwesomeIcons.faceSmile,
      color: Color(0xFFFCE4EC),
      topBorderColor: Color(0xFFF06292),
      steps: [
        'Exercise for at least 20 minutes — it releases endorphins naturally.',
        'Connect with one person today — a text, call, or coffee.',
        'Do one thing you enjoy, even for just 10 minutes.',
        'Listen to music that uplifts or energizes you.',
        'Act of kindness: do something for someone else — it boosts your mood too.',
      ],
    ),
    const ResourceModel(
      id: 's4',
      title: 'Building Resilience',
      description: 'Stay strong through adversity',
      content: 'Mindsets for bouncing back.',
      category: ResourceCategory.selfHelp,
      icon: FontAwesomeIcons.seedling,
      color: Color(0xFFF1F8E9),
      topBorderColor: Color(0xFF81C784),
      steps: [
        'Reframe setbacks as learning opportunities, not failures.',
        'Build your support network — don\'t try to cope alone.',
        'Practice self-compassion: talk to yourself like a good friend would.',
        'Focus on what you can control; let go of what you can\'t.',
        'Keep a "wins journal" — write down small victories every day.',
      ],
    ),
    const ResourceModel(
      id: 's5',
      title: 'Stress Relief',
      description: 'Decompress and find peace',
      content: 'Quick ways to lower your stress levels.',
      category: ResourceCategory.selfHelp,
      icon: FontAwesomeIcons.om,
      color: Color(0xFFF3E5F5),
      topBorderColor: Color(0xFFBA68C8),
      steps: [
        'Take short 5-minute breaks every hour when working.',
        'Declutter one small area — a tidy space leads to a calmer mind.',
        'Try the 2-minute rule: if a task takes less than 2 minutes, do it now.',
        'Say no to commitments that drain you without giving back.',
        'Create an evening wind-down routine to signal your brain it\'s time to rest.',
      ],
    ),
    const ResourceModel(
      id: 's6',
      title: 'Better Sleep',
      description: 'Optimize your rest',
      content: 'Sleep hygiene for better mental health.',
      category: ResourceCategory.selfHelp,
      icon: FontAwesomeIcons.moon,
      color: Color(0xFFE8EAF6),
      topBorderColor: Color(0xFF7986CB),
      steps: [
        'Keep your bedroom cool, dark, and quiet.',
        'Avoid screens 60 minutes before bed — use blue light filters if needed.',
        'Don\'t lie in bed awake for more than 20 minutes; get up and do something calm.',
        'Avoid alcohol close to bedtime — it disrupts REM sleep.',
        'Write tomorrow\'s to-do list before bed to clear your mind.',
      ],
    ),
  ];

  static List<ResourceModel> getByCategory(ResourceCategory category) {
    switch (category) {
      case ResourceCategory.articles:
        return articles;
      case ResourceCategory.breathing:
        return breathingExercises;
      case ResourceCategory.meditation:
        return meditations;
      case ResourceCategory.selfHelp:
        return selfHelpTips;
    }
  }
}
