# Домашнее задание по теме: "Teamcity"

## Подготовка к выполнению

1. В Yandex Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`.
2. Дождитесь запуска teamcity, выполните первоначальную настройку.
3. Создайте ещё один инстанс (2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`.
4. Авторизуйте агент.
  
    #### Результат:

    ![](./assets/images/yc_teamcity.png)

    ![](./assets/images/teamcity_agent.png)

5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity).
6. Создайте VM (2CPU4RAM) и запустите [playbook](./infrastructure).

    #### Результат:

    ```bash
    ansible-playbook -i inventory/cicd/hosts.yml site.yml 
    
    PLAY [Get Nexus installed] ************************************************************************************************************************************************
    
    TASK [Gathering Facts] ****************************************************************************************************************************************************
    ok: [nexus-01]
    
    TASK [Create Nexus group] *************************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Create Nexus user] **************************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Install JDK] ********************************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Create Nexus directories] *******************************************************************************************************************************************
    changed: [nexus-01] => (item=/home/nexus/log)
    changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3)
    changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3/etc)
    changed: [nexus-01] => (item=/home/nexus/pkg)
    changed: [nexus-01] => (item=/home/nexus/tmp)
    
    TASK [Download Nexus] *****************************************************************************************************************************************************
    [WARNING]: Module remote_tmp /home/nexus/.ansible/tmp did not exist and was created with a mode of 0700, this may cause issues when running as another user. To avoid
    this, create the remote_tmp dir with the correct permissions manually
    changed: [nexus-01]
    
    TASK [Unpack Nexus] *******************************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Link to Nexus Directory] ********************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Add NEXUS_HOME for Nexus user] **************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Add run_as_user to Nexus.rc] ****************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Raise nofile limit for Nexus user] **********************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Create Nexus service for SystemD] ***********************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Ensure Nexus service is enabled for SystemD] ************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Create Nexus vmoptions] *********************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Create Nexus properties] ********************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Lower Nexus disk space threshold] ***********************************************************************************************************************************
    skipping: [nexus-01]
    
    TASK [Start Nexus service if enabled] *************************************************************************************************************************************
    changed: [nexus-01]
    
    TASK [Ensure Nexus service is restarted] **********************************************************************************************************************************
    skipping: [nexus-01]
    
    TASK [Wait for Nexus port if started] *************************************************************************************************************************************
    ok: [nexus-01]
    
    PLAY RECAP ****************************************************************************************************************************************************************
    nexus-01                   : ok=17   changed=15   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
    ```

## Основная часть

1. Создайте новый проект в teamcity на основе fork.

    #### Результат:

    ![](./assets/images/teamcity_project.png)

2. Сделайте autodetect конфигурации.

    #### Результат:

    ![](./assets/images/teamcity_project_2.png)

3. Сохраните необходимые шаги, запустите первую сборку master.

    #### Результат:

    ![](./assets/images/teamcity_build.png)

4. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`.

    #### Результат:

    ![](./assets/images/teamcity_build_steps.png)

5. Для deploy будет необходимо загрузить [settings.xml](./teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.

    #### Результат:

    ![](./assets/images/teamcity_build_settings.png)

6. В pom.xml необходимо поменять ссылки на репозиторий и nexus.

    #### Результат:

    [example-teamcity/pom.xml commit](https://github.com/ivanmanokhin/example-teamcity/commit/04817fd18481ff6ada91cdab922d2b4a60cc635f)

7. Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.

    #### Результат:

    ![](./assets/images/teamcity_build_2.png)

    ![](./assets/images/nexus_deploy.png)

8. Мигрируйте `build configuration` в репозиторий.

    #### Результат:

    ![](./assets/images/teamcity_sync.png)

9. Создайте отдельную ветку `feature/add_reply` в репозитории.
10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`.
11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике.
12. Сделайте push всех изменений в новую ветку репозитория.

    #### Результат:

    [example-teamcity (feature/add_reply)](https://github.com/ivanmanokhin/example-teamcity/tree/feature/add_reply)

13. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.

    #### Результат:

    ![](./assets/images/teamcity_build_3.png)

14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`.

    #### Результат:

    [merge commit](https://github.com/ivanmanokhin/example-teamcity/commit/218a0cc99912ed477a0a99c61f82a59469ccc5ba)

15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`.
16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки.

    #### Результат:

    ![](./assets/images/teamcity_target_jar.png)

17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.

    #### Результат:

    ![](./assets/images/teamcity_jar.png)

18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.
19. В ответе пришлите ссылку на репозиторий.

    #### Результат:

    [example-teamcity](https://github.com/ivanmanokhin/example-teamcity)
